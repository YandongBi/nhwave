     Module GLOBAL
# if defined (PARALLEL)
     use mpi
# endif
     implicit none

     ! define precision
# if defined (DOUBLE_PRECISION)
     integer, parameter :: SP=8
# if defined (PARALLEL)
     integer, parameter :: MPI_SP=MPI_DOUBLE_PRECISION
# endif
# else
     integer, parameter :: SP=SELECTED_REAL_KIND(6,30)
# if defined (PARALLEL)
     integer, parameter :: MPI_SP=MPI_REAL
# endif
# endif

     ! define parameters
     real(SP), parameter :: pi=3.141592653
     real(SP), parameter :: Small=1.0e-16
     real(SP), parameter :: Large=10000000.0
     real(SP), parameter :: Grav=9.81
     real(SP), parameter :: Zero=0.0
     real(SP), parameter :: One=1.0
     real(SP), parameter :: Rho0=1000.0
     real(SP), parameter :: RhoA=1.20
     real(SP), parameter :: Srho = 2650.
     real(SP), parameter :: Kappa=0.41
     integer,  parameter :: MaxNumFreq=500
     integer,  parameter :: MaxNumDir=100

     ! ghost cells (>=1)
     integer, parameter :: Nghost=2

     ! define characters
     character(len=80) :: TITLE
     character(len=80) :: RESULT_FOLDER
     character(len=80) :: HIGH_ORDER
     character(len=80) :: TIME_ORDER
     character(len=80) :: WaveMaker
     character(len=80) :: DEPTH_TYPE
     character(len=80) :: dt_constraint
     character(len=80) :: CONVECTION

# if defined (PARALLEL)
     integer :: myid,ier
     integer :: comm2d
     integer :: n_west,n_east,n_suth,n_nrth
     integer :: npx,npy
     integer :: ndims=2
     integer :: NumP
     integer, dimension(2) :: dims,coords
     logical, dimension(2) :: periods
     logical :: reorder=.true.
# endif


# if defined (BUBBLE)
     integer, parameter :: Mg = 20
     real(SP), parameter :: Surface_Tension = 71.97e-3
     real(SP), parameter :: Con_b = 0.5
     real(SP), parameter :: Eps_Cric = 0.01
     real(SP), parameter :: TIM_B = 10.0
     real(SP), dimension(:), allocatable :: Rbg,DRbg,Wbg,Entrain
     real(SP), dimension(:,:,:,:), allocatable :: Nbg,DNbg,DNbg0
     real(SP), dimension(:,:,:), allocatable :: Vbg
# endif

# if defined (CORALREEF)
     real(SP) :: Creef
# endif

# if defined (SEDIMENT)
     real(SP), parameter :: Spor = 0.4
     logical :: COUPLE_FS,BED_LOAD
     character(len=80) :: Sed_Type
     real(SP), dimension(:,:),   allocatable :: SSour,Taub,Bed,Bed0,Qbedx,Qbedy, &
                                                QbxAvg,QbyAvg
     real(SP), dimension(:,:),   allocatable :: Sed_X0,Sed_Xn,Smean,TotDep
     real(SP), dimension(:,:,:), allocatable :: Conc,DConc,DConc0,Euler_Smean
     real(SP) :: Update_Bed_T,MorDt,SD50,Af,Shields_c,Tau_ce,Tau_cd,Erate,  &
                 Tim_Sedi,Wset,Sedi_Ws
     integer :: ntyws,nbed
# endif

# if defined (SALINITY)
     real(SP), dimension(:,:,:), allocatable :: Sali,DSali,DSali0
     real(SP), dimension(:,:), allocatable :: Sin_X0,Sin_Xn 
# endif

# if defined (TEMPERATURE)
     real(SP), dimension(:,:,:), allocatable :: Temp,DTemp,DTemp0
     real(SP), dimension(:,:), allocatable :: Tin_X0,Tin_Xn
# endif

# if defined (VEGETATION)
     character(len=80) :: Veg_Type
     real(SP) :: VegH,VegDens,Vegbv,VegDrag,VegVM,Veg_X0,Veg_Xn,Veg_Y0,Veg_Yn,EI
     real(SP), dimension(:,:,:), allocatable :: Prod_v
     real(SP), dimension(:,:), allocatable :: FVegH,Foliage
# endif

# if defined (LANDSLIDE)
     character(len=80) :: SlideType
     real(SP) :: SlideT,SlideL,SlideW,SlideAngle,SlopeAngle,SlideD,SlideX0,SlideY0
     real(SP) :: SlideUt,SlideA0,SlideDens
# endif

# if defined (BALANCE2D)
     real(SP), dimension(:,:), allocatable :: DUDT2D,DVDT2D,DEDX2D,DEDY2D,DPDX2D,DPDY2D,DIFFX2D,DIFFY2D,  &
                TAUBX2D,TAUBY2D,FVEGX2D,FVEGY2D,ADVX2D,ADVY2D
# endif

# if defined (POROUSMEDIA)
     real(SP), dimension(:,:,:), allocatable :: Porosity, HyCk
     real(SP), parameter :: Carman_Koseny_Const = 1.6e3
# endif

# if defined (TWOLAYERSLIDE)
     real(SP) :: SlideT,SlideW,SlideL,SlideAngle,SlopeAngle,SlideX0,SlideY0,SlideDens,SlideVisc
     real(SP) :: SlideLambda,SlideIniU,PhiInt,PhiBed,Cf_ul,Cs_ul
     real(SP), dimension(:,:), allocatable :: Ha0,Ha,Hs,Ua0,Va0,Ua,Va,HUa0,HVa0,HUa,HVa, &
                                              HUaxL,HUaxR,HVaxL,HVaxR,HUayL,HUayR,HVayL,HVayR, &
                                              Eax,Eay,EaxL,EaxR,EayL,EayR,Fax,Fay,FaxL,FaxR,FayL, &
                                              FayR,Gax,Gay,GaxL,GaxR,GayL,GayR,SorceaX,SorceaY, &
                                              DelxHa,DelxUa,DelxVa,DelxHUa,DelxHVa,DelyHa,DelyUa,DelyVa, &
                                              DelyHUa,DelyHVa,HaxL,HaxR,UaxL,UaxR,VaxL,VaxR,HayL,HayR, &
                                              UayL,UayR,VayL,VayR,Kap,KapxL,KapxR,KapyL,KapyR,SaxL,SaxR, &
                                              SaxS,SayL,SayR,SayS,DelxKap,DelyKap,DepAng,CosAng, &
                                              ForceX_UL,ForceY_UL
     integer, dimension(:,:), allocatable :: Maska
# endif

     ! define output logical parameters
     logical :: ANA_BATHY,NON_HYDRO,VISCOUS_FLOW,SPONGE_ON,OUT_H,OUT_E,OUT_U,OUT_V,OUT_W,OUT_P, &
                OUT_K,OUT_D,OUT_S,OUT_C,OUT_B,OUT_A,OUT_F,OUT_T,OUT_G,OUT_I,PERIODIC_X,PERIODIC_Y, &
                WAVE_AVERAGE_ON,ADV_HLLC,BAROTROPIC,RIGID_LID,BED_CHANGE,EXTERNAL_FORCING,STATIONARY, &
                INITIAL_EUVW,INITIAL_SALI,RHEOLOGY_ON

     ! variables
     integer :: It_Order,Ibeg,Iend,Iend1,Jbeg,Jend,Jend1,Kbeg,Kend,Kend1,PX,PY,IVturb,IHturb,Iws,  &
                Mglob,Nglob,Kglob,Mloc,Nloc,Kloc,Mloc1,Nloc1,Kloc1,Icount,RUN_STEP,Ivgrd,SIM_STEPS,Ibot, &
                NumFreq,NumDir,NSTAT,WaveheightID
     integer :: Bc_X0,Bc_Xn,Bc_Y0,Bc_Yn,Bc_Z0,Bc_Zn
     real(SP) :: dt,dt_old,dt_min,dt_max,dt_ini,dx,dy,Theta,CFL,VISCOUS_NUMBER,MinDep,TIME,TOTAL_TIME,Plot_Intv,  &
                 Screen_Intv,Screen_Count,Plot_Count,Visc,Cvs,Chs,Zob,Tke_min,Eps_min,Cmut_min,Cd0,Plot_Start,Plot_Intv_Stat, &
                 Plot_Count_Stat,xstat(20),ystat(20),Wave_Ave_Start,Wave_Ave_End,Schmidt,TRamp,Grd_R,Yield_Stress,Plastic_Visc, &
                 Mud_Visc,Water_Depth,WindU,WindV,slat,fcor
     real(SP) :: Amp_Wave,Per_Wave,Dep_Wave,Theta_Wave,Freq(MaxNumFreq),Dire(MaxNumDir),Wave_Spc2d(MaxNumDir,MaxNumFreq), &
                 Random_Phs(MaxNumDir,MaxNumFreq),Hm0,Tp,Freq_Min,Freq_Max,Jon_Spc(MaxNumFreq),RanPhs(MaxNumFreq)
     real(SP) :: Sponge_West_Width,Sponge_East_Width,Sponge_South_Width,Sponge_North_Width,R_Sponge,A_Sponge, &
                 Xsource_West,Xsource_East,Ysource_Suth,Ysource_Nrth
     real(SP), dimension(3) :: ALPHA,BETA

     ! real arrays
     real(SP), dimension(:), allocatable :: x,xc,y,yc,sig,dsig,sigc,Ein_X0,Din_X0,Ein_Xn,Din_Xn
     real(SP), dimension(:,:), allocatable :: Ho,H,Hc,HCG,Hc0,Hfx,Hfy,DeltH,DeltHo,Delt2H,DelxH,DelyH,D,D0,Eta,Eta0,Eta00, &
                                              SourceX,SourceY,SourceC,DxL,DxR,DyL,DyR,EtaxL,EtaxR,EtayL,EtayR, &
                                              DelxEta,DelyEta,DelxD,DelyD,Uin_X0,Vin_X0,Win_X0,Uin_Xn,Vin_Xn, &
                                              Win_Xn,Bc_Prs,Sponge,Setup,WaveHeight,Umean,Vmean,Emax,Emin,WdU,WdV,Wsx,Wsy
     real(SP), dimension(:,:,:), allocatable :: U,V,W,U0,V0,W0,U00,V00,W00,Omega,P,DU,DV,DW,DU0,DV0,DW0, &
                                                UxL,UxR,VxL,VxR,WxL,WxR,DUxL,DUxR,DVxL,DVxR,DWxL, &
                                                DWxR,UyL,UyR,VyL,VyR,WyL,WyR,DUyL,DUyR,DVyL,DVyR,DWyL,DWyR, &
                                                UzL,UzR,VzL,VzR,WzL,WzR,OzL,OzR,SxL,SxR,SxS,SyL,SyR,SyS,ExL,ExR,FxL, &
                                                FxR,GxL,GxR,HxL,HxR,EyL,EyR,FyL,FyR,GyL,GyR,HyL,HyR,Ex,Ey,Fx, &
                                                Fy,Fz,Gx,Gy,Gz,Hx,Hy,Hz,DelxU,DelyU,DelzU,DelxV,DelyV,DelzV, &
                                                DelxW,DelyW,DelzW,DelxDU,DelyDU,DelxDV,DelyDV,DelxDW,DelyDW, &
                                                DelzO,Uf,Vf,Wf,Cmu,CmuHt,CmuVt,CmuR,Diffxx,Diffxy,Diffxz,Diffyx,  &
                                                Diffyy,Diffyz,Diffzx,Diffzy,Diffzz,DelxSc,DelySc,Rho,Rmean,Tke,Eps,Skl, &
                                                DTke,DEps,DTke0,DEps0,Prod_s,Prod_b,Richf,Lag_Umean,Lag_Vmean,Lag_Wmean, &
                                                Euler_Umean,Euler_Vmean,Euler_Wmean,DRhoX,DRhoY,ExtForceX,ExtForceY, &
                                                UpWp,PresForceX,PresForceY,PresForceZ
     real(SP), dimension(:,:,:,:), allocatable :: UGrad,VGrad,WGrad

     ! integer arrays
     integer, dimension(:,:), allocatable :: Mask,Mask_Struct,Mask9,Brks,Num_Zero_Up
     integer, dimension(:,:,:), allocatable :: IsMove
     
     ! poisson solvers
     integer  :: itmax,isolver,neqns
     real(SP) :: tol
     real(SP), dimension(:),   allocatable :: Rhs
     integer,  dimension(:),   allocatable :: JCoef
     real(SP), dimension(:,:), allocatable :: Coef

     End Module GLOBAL
