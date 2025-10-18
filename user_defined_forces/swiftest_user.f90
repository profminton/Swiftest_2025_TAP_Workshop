submodule(swiftest) s_swiftest_user
   use swiftest
contains
   module subroutine swiftest_user_kick_getacch_body(self, nbody_system, param, t, lbeg)
    !! author: David A. Minton
    !!
    !! Add user-supplied heliocentric accelerations to planets.
    !!
    implicit none
    ! Arguments
    class(swiftest_body),         intent(inout) :: self   
        !! Swiftest particle data structure
    class(swiftest_nbody_system), intent(inout) :: nbody_system 
        !! Swiftest nbody_system_object
    class(swiftest_parameters),   intent(inout) :: param  
        !! Current run configuration parameters user parameters
    real(DP),                     intent(in)    :: t      
        !! Current time
    logical,                      intent(in)    :: lbeg   
        !! Logical flag that determines whether or not this is the beginning or end of the step

    integer(I4B), save :: jupiter_id = -1
    integer(I4B) :: i
    integer(I4B) :: j

    ! If jupiter_id is -1, this means we haven't found it yet
    if (jupiter_id == -1) then
    ! Search through all massive bodies to find Jupiter's id
    do j = 1, nbody_system%pl%nbody
        if (trim(adjustl(nbody_system%pl%info(j)%name)) == "Jupiter") then 
            jupiter_id = nbody_system%pl%id(j)
        end if
    end do
    end if

    select type(body => self)
    class is (swiftest_pl)
    do i = 1, body%nbody
        if (body%id(i) == jupiter_id) then
            ! Apply a custom acceleration to Jupiter only
            body%ah(3,i) = body%ah(3,i) + 1.0e-4_DP  
        end if
    end do
    end select

    return
    end subroutine swiftest_user_kick_getacch_body

end submodule s_swiftest_user
