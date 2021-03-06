!|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

 module horizontal_mix

!BOP
! !MODULE: horizontal_mix
!
! !DESCRIPTION:
!  This module contains driver routines for managing the individual
!  horizontal tracer and momentum mixing modules.
!
! !REVISION HISTORY:
!  SVN:$Id: horizontal_mix.F90 12674 2008-10-31 22:21:32Z njn01 $
!
! !USES:

   use POP_KindsMod
   use POP_ErrorMod
   use POP_ConstantsMod

   use kinds_mod
   use blocks, only: nx_block, ny_block, block
   use distribution, only: 
   use POP_DomainSizeMod, only : POP_km, POP_nt
   use domain, only: nblocks_clinic, distrb_clinic
   use constants, only: c0, blank_fmt, delim_fmt, ndelim_fmt
   use communicate, only: my_task, master_task
   use time_management, only: mix_pass
   use broadcast, only: broadcast_scalar
   use grid, only: KMT, dz
   use io_types, only: nml_in, nml_filename, stdout
   use hmix_del2, only: init_del2u, init_del2t, hdiffu_del2, hdifft_del2
   use hmix_del4, only: init_del4u, init_del4t, hdiffu_del4, hdifft_del4
   use hmix_gm, only: init_gm, hdifft_gm
   use hmix_aniso, only: init_aniso, hdiffu_aniso
   use topostress, only: ltopostress
   use tavg, only: define_tavg_field, tavg_requested, accumulate_tavg_field
   use timers, only: timer_start, timer_stop, get_timer
   use exit_mod, only: sigAbort, exit_pop
   use mix_submeso, only: init_submeso

   implicit none
   private
   save

! !PUBLIC MEMBER FUNCTIONS:

   public :: init_horizontal_mix, &
             hdiffu, hdifft

!EOP
!BOC
!-----------------------------------------------------------------------
!
!  horizontal mixing choices
!
!-----------------------------------------------------------------------

   integer (POP_i4), parameter :: &! available choices for mixing type
      hmix_momentum_type_del2 = 1,  &
      hmix_momentum_type_del4 = 2,  &
      hmix_momentum_type_anis = 3,  &
      hmix_tracer_type_del2 = 1,    &
      hmix_tracer_type_del4 = 2,    &
      hmix_tracer_type_gm   = 3

   integer (POP_i4) ::            &
      hmix_momentum_itype,          &! users choice for type of mixing
      hmix_tracer_itype,            &! users choice for type of mixing
      tavg_HDIFT,                   &! tavg id for horizontal diffusion
      tavg_HDIFS                     ! tavg id for horizontal diffusion

   logical (log_kind) ::            &
      lsubmesoscale_mixing           ! if true, submesoscale mixing is on


!-----------------------------------------------------------------------
!
!  timers
!
!-----------------------------------------------------------------------

   integer (POP_i4) :: &
      timer_hdiffu,      &! timer for horizontal momentum mixing
      timer_hdifft        ! timer for horizontal tracer   mixing

!EOC
!***********************************************************************

 contains

!***********************************************************************
!BOP
! !IROUTINE: init_horizontal_mix
! !INTERFACE:

 subroutine init_horizontal_mix(errorCode)

! !DESCRIPTION:
!  Initializes choice of mixing method based on namelist input.
!
! !REVISION HISTORY:
!  same as module
!
! !OUTPUT PARAMETERS:

   integer (POP_i4), intent(out) :: &
      errorCode             ! returned error code

!EOP
!BOC
!-----------------------------------------------------------------------
!
!  local variables
!
!-----------------------------------------------------------------------

   integer (POP_i4) :: nml_error  ! error flag for namelist

   character (POP_charLength) ::  &! character choice for type of mixing
      hmix_momentum_choice, &
      hmix_tracer_choice

   namelist /hmix_nml/ hmix_momentum_choice, hmix_tracer_choice,  &
                       lsubmesoscale_mixing

!-----------------------------------------------------------------------
!
!  read namelist input
!
!-----------------------------------------------------------------------

   errorCode = POP_Success

   hmix_momentum_choice = 'unknown_hmix_momentum_choice'
   hmix_tracer_choice = 'unknown_hmix_tracer_choice'
   lsubmesoscale_mixing = .false.

   if (my_task == master_task) then
      open (nml_in, file=nml_filename, status='old',iostat=nml_error)
      if (nml_error /= 0) then
         nml_error = -1
      else
         nml_error =  1
      endif
      do while (nml_error > 0)
         read(nml_in, nml=hmix_nml, iostat=nml_error)
      end do
      if (nml_error == 0) close(nml_in)
   endif

   call broadcast_scalar(nml_error, master_task)
   if (nml_error /= 0) then
      call exit_POP(sigAbort,'ERROR reading hmix_nml')
   endif

   if (my_task == master_task) then
      write(stdout,blank_fmt)
      write(stdout,ndelim_fmt)
      write(stdout,blank_fmt)
      write(stdout,'(a25)') 'Horizontal mixing options'
      write(stdout,blank_fmt)
      write(stdout,*) ' hmix_nml namelist settings:'
      write(stdout,blank_fmt)
      write(stdout,hmix_nml)
      write(stdout,blank_fmt)
      write(stdout,delim_fmt)

      select case (hmix_momentum_choice(1:4))
      case ('del2')
         hmix_momentum_itype = hmix_momentum_type_del2
         write(stdout,'(a42)') &
           'Laplacian horizontal momentum mixing used.'
      case ('del4')
         hmix_momentum_itype = hmix_momentum_type_del4
         write(stdout,'(a43)') &
           'Biharmonic horizontal momentum mixing used.'
      case ('anis')
         hmix_momentum_itype = hmix_momentum_type_anis
         write(stdout,'(a44)') &
           'Anisotropic horizontal momentum mixing used.'
      case ('gent')
         hmix_momentum_itype = -1000
      case default
         hmix_momentum_itype = -2000
      end select

      select case (hmix_tracer_choice(1:4))
      case ('del2')
         hmix_tracer_itype = hmix_tracer_type_del2
         write(stdout,'(a44)') &
           'Laplacian horizontal tracer   mixing chosen.'
      case ('del4')
         hmix_tracer_itype = hmix_tracer_type_del4
         write(stdout,'(a43)') &
           'Biharmonic horizontal tracer   mixing used.'
      case ('gent')
         hmix_tracer_itype = hmix_tracer_type_gm
         write(stdout,'(a35)') &
          'Gent-McWilliams tracer mixing used.'
      case default
         hmix_tracer_itype = -1000
      end select

      if ( lsubmesoscale_mixing ) then
        write (stdout,blank_fmt)
        write (stdout, '(a48)') &
         'Submesoscale mixed layer parameterization is on.'
      endif

   endif

   call broadcast_scalar(hmix_momentum_itype, master_task)
   call broadcast_scalar(hmix_tracer_itype,   master_task)
   call broadcast_scalar(lsubmesoscale_mixing,master_task)

   if (hmix_momentum_itype == -1000) then
      call exit_POP(sigAbort, &
              'Gent-McWilliams can only be used for tracer mixing')
   else if (hmix_momentum_itype == -2000) then
      call exit_POP(sigAbort, &
                    'Unknown type for horizontal momentum mixing')
   endif

   if (hmix_tracer_itype == -1000) then
      call exit_POP(sigAbort, &
                    'Unknown type for horizontal tracer mixing')
   endif

   if ( lsubmesoscale_mixing  .and.  &
        hmix_tracer_itype /= hmix_tracer_type_gm ) then
     call exit_POP(sigAbort, &
                   'Submesoscale mixing can be used only when GM is on')
   endif

!-----------------------------------------------------------------------
!
!  calculate additional coefficients based on mixing parameterization
!  initialize timers
!
!-----------------------------------------------------------------------

   select case (hmix_momentum_itype)
   case(hmix_momentum_type_del2)
      call init_del2u(errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'init_hmix: error initializing del2u')
         return
      endif

      call get_timer(timer_hdiffu,'HMIX_MOMENTUM_DEL2', &
                                  nblocks_clinic, distrb_clinic%nprocs)

   case(hmix_momentum_type_del4)
      call init_del4u(errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'init_hmix: error initializing del4u')
         return
      endif

      call get_timer(timer_hdiffu,'HMIX_MOMENTUM_DEL4', &
                                  nblocks_clinic, distrb_clinic%nprocs)

   case(hmix_momentum_type_anis)
      call init_aniso (errorCode)
      call get_timer(timer_hdiffu,'HMIX_MOMENTUM_ANISO', &
                                  nblocks_clinic, distrb_clinic%nprocs)
   end select

   select case (hmix_tracer_itype)
   case(hmix_tracer_type_del2)
      call init_del2t(errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'init_hmix: error initializing del2t')
         return
      endif

      call get_timer(timer_hdifft,'HMIX_TRACER_DEL2', &
                                  nblocks_clinic, distrb_clinic%nprocs)

   case(hmix_tracer_type_del4)

      call init_del4t(errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'init_hmix: error initializing del4t')
         return
      endif

      call get_timer(timer_hdifft,'HMIX_TRACER_DEL4', &
                                  nblocks_clinic, distrb_clinic%nprocs)

   case(hmix_tracer_type_gm)
      call init_gm(errorCode)  ! variables used by GM parameterization

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'init_horizontal_mix: error in init_gm')
         return
      endif

      call get_timer(timer_hdifft,'HMIX_TRACER_GM', &
                                  nblocks_clinic, distrb_clinic%nprocs)

   end select

!-----------------------------------------------------------------------
!
!  initialize submesoscale mixing
!
!-----------------------------------------------------------------------

   if ( lsubmesoscale_mixing )  then
      call init_submeso(errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'init_horizontal_mix: error in init_submeso')
         return
      endif

   endif

!-----------------------------------------------------------------------
!
!  check for compatibility with topostress
!
!-----------------------------------------------------------------------

!maltrud merge no problems with topostress and hmix after del4 aniso added
!  if (ltopostress .and. &
!      hmix_momentum_itype /= hmix_momentum_type_del2) then
!     if (my_task == master_task) write(stdout,'(a59)') &
!        'WARNING: TOPOSTRESS HAS NO EFFECT IF DEL2 MIXING NOT CHOSEN'
!  endif

!-----------------------------------------------------------------------
!
!  define tavg field for tavg diagnostics
!
!-----------------------------------------------------------------------

   call define_tavg_field(tavg_HDIFT,'HDIFT',2,                            &
                    long_name='Vertically Integrated Horz Mix T tendency', &
                          units='centimeter degC/s', grid_loc='2110')

   call define_tavg_field(tavg_HDIFS,'HDIFS',2,                             &
                    long_name='Vertically Integrated Horz Diff S tendency', &
                          units='centimeter gram/gram/s', grid_loc='2110')

!-----------------------------------------------------------------------
!EOC

 end subroutine init_horizontal_mix

!***********************************************************************
!BOP
! !IROUTINE: hdiffu
! !INTERFACE:

 subroutine hdiffu(k,HDUK,HDVK,UMIXK,VMIXK,this_block, errorCode)

! !DESCRIPTION:
!  This routine returns tendencies for horizontal diffusion of
!  momentum.  It is a driver routine which simply branches to the
!  proper horizontal mix routine based on the user choice of mixing
!  method.
!
! !REVISION HISTORY:
!  same as module

! !INPUT PARAMETERS:

   integer (POP_i4), intent(in) :: k   ! depth level index

   real (POP_r8), dimension(nx_block,ny_block), intent(in) :: &
      UMIXK, VMIXK         ! U,V at level k and mix time level

   type (block), intent(in) :: &
      this_block           ! block information for this subblock

! !OUTPUT PARAMETERS:

   real (POP_r8), dimension(nx_block,ny_block), intent(out) :: &
      HDUK,                   &! returned as Hdiff(U) at level k
      HDVK                     ! returned as Hdiff(V) at level k

   integer (POP_i4), intent(out) :: &
      errorCode                ! returned error code

!EOP
!BOC
!-----------------------------------------------------------------------
!
!  branch to the proper mix routine
!
!-----------------------------------------------------------------------

   errorCode = POP_Success

   call timer_start(timer_hdiffu, block_id=this_block%local_id)

   select case (hmix_momentum_itype)

   case (hmix_momentum_type_del2)

      call hdiffu_del2(k, HDUK, HDVK, UMIXK, VMIXK, this_block, &
                          errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'hdiffu: error in hdiffu_del2')
         return
      endif

   case (hmix_momentum_type_del4)

      call hdiffu_del4(k, HDUK, HDVK, UMIXK, VMIXK, this_block, &
                          errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'hdiffu: error in hdiffu_del4')
         return
      endif

   case (hmix_momentum_type_anis)
      call hdiffu_aniso(k, HDUK, HDVK, UMIXK, VMIXK, this_block, &
                           errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'hdiffu: error in hdiffu_aniso')
         return
      endif

   end select

   call timer_stop(timer_hdiffu, block_id=this_block%local_id)

!-----------------------------------------------------------------------
!EOC

 end subroutine hdiffu

!***********************************************************************
!BOP
! !IROUTINE: hdifft
! !INTERFACE:

 subroutine hdifft(k, HDTK, TMIX, UMIX, VMIX, this_block, errorCode)

! !DESCRIPTION:
!  This routine returns tendencies for horizontal diffusion of
!  tracers.  It is a driver routine which simply branches to the
!  proper horizontal mix routine based on the user choice of mixing
!  method.
!
! !REVISION HISTORY:
!  same as module

! !INPUT PARAMETERS:

   integer (POP_i4), intent(in) :: k   ! depth level index

   real (POP_r8), dimension(nx_block,ny_block,POP_km,POP_nt), intent(in) :: &
      TMIX     ! tracers at mix time level

   real (POP_r8), dimension(nx_block,ny_block,POP_km), intent(in) :: &
      UMIX, VMIX   ! U,V velocities at mix time level

   type (block), intent(in) :: &
      this_block           ! block information for this subblock

! !OUTPUT PARAMETERS:

   real (POP_r8), dimension(nx_block,ny_block,POP_nt), intent(out) :: &
      HDTK                ! Hdiff(T) for nth tracer at level k

   integer (POP_i4), intent(out) :: &
      errorCode                ! returned error code

!EOP
!BOC
!-----------------------------------------------------------------------
!
!  local variables
!
!-----------------------------------------------------------------------

   integer (POP_i4) :: &
      bid                 ! local block id

   real (POP_r8), dimension(nx_block,ny_block) :: &
     WORK                 ! temporary to hold tavg field

!-----------------------------------------------------------------------
!
!  branch to the proper mix routine
!
!-----------------------------------------------------------------------

   errorCode = POP_Success

   bid = this_block%local_id

   call timer_start(timer_hdifft, block_id=bid)

   select case (hmix_tracer_itype)
   case (hmix_tracer_type_del2)

      call hdifft_del2(k, HDTK, TMIX, this_block, errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'hdifft: error in hdifft_del2')
         return
      endif

   case (hmix_tracer_type_del4)

      call hdifft_del4(k, HDTK, TMIX, this_block, errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'hdifft: error in hdifft_del4')
         return
      endif

   case (hmix_tracer_type_gm)

      call hdifft_gm(k, HDTK, TMIX, UMIX, VMIX, this_block, errorCode)

      if (errorCode /= POP_Success) then
         call POP_ErrorSet(errorCode, &
            'hdifft: error in hdifft_gm')
         return
      endif

   end select

   call timer_stop(timer_hdifft, block_id=bid)

!-----------------------------------------------------------------------
!
!  compute tavg diagnostic if requested
!
!-----------------------------------------------------------------------

   if (tavg_requested(tavg_HDIFT) .and. mix_pass /= 1) then

     where (k <= KMT(:,:,bid))
        WORK = dz(k)*HDTK(:,:,1)
     elsewhere
        WORK = c0
     end where

     call accumulate_tavg_field(WORK,tavg_HDIFT,bid,k)
   endif

   if (tavg_requested(tavg_HDIFS) .and. mix_pass /= 1) then

     where (k <= KMT(:,:,bid))
        WORK = dz(k)*HDTK(:,:,2)
     elsewhere
        WORK = c0
     end where

     call accumulate_tavg_field(WORK,tavg_HDIFS,bid,k)
   endif

!-----------------------------------------------------------------------
!EOC

 end subroutine hdifft

!***********************************************************************

 end module horizontal_mix

!|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
