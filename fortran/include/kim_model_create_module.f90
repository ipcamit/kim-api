!
! CDDL HEADER START
!
! The contents of this file are subject to the terms of the Common Development
! and Distribution License Version 1.0 (the "License").
!
! You can obtain a copy of the license at
! http://www.opensource.org/licenses/CDDL-1.0.  See the License for the
! specific language governing permissions and limitations under the License.
!
! When distributing Covered Code, include this CDDL HEADER in each file and
! include the License file in a prominent location with the name LICENSE.CDDL.
! If applicable, add the following below this CDDL HEADER, with the fields
! enclosed by brackets "[]" replaced with your own identifying information:
!
! Portions Copyright (c) [yyyy] [name of copyright owner]. All rights reserved.
!
! CDDL HEADER END
!

!
! Copyright (c) 2016--2018, Regents of the University of Minnesota.
! All rights reserved.
!
! Contributors:
!    Ryan S. Elliott
!

!
! Release: This file is part of the kim-api.git repository.
!


module kim_model_create_module
  use, intrinsic :: iso_c_binding
  implicit none
  private

  public &
    ! Derived types
    kim_model_create_handle_type, &

    ! Constants
    KIM_MODEL_CREATE_NULL_HANDLE, &

    ! Routines
    operator (.eq.), &
    operator (.ne.), &
    kim_set_model_numbering, &
    kim_set_influence_distance_pointer, &
    kim_set_neighbor_list_pointers, &
    kim_set_refresh_pointer, &
    kim_set_destroy_pointer, &
    kim_set_compute_arguments_create_pointer, &
    kim_set_compute_arguments_destroy_pointer, &
    kim_set_compute_pointer, &
    kim_set_species_code, &
    kim_set_parameter_pointer, &
    kim_set_model_buffer_pointer, &
    kim_set_units, &
    kim_convert_unit, &
    kim_log_entry, &
    kim_to_string


  type, bind(c) :: kim_model_create_handle_type
    type(c_ptr) :: p = c_null_ptr
  end type kim_model_create_handle_type

  type(kim_model_create_handle_type), protected, save &
    :: KIM_MODEL_CREATE_NULL_HANDLE

  interface operator (.eq.)
    module procedure kim_model_create_handle_equal
  end interface operator (.eq.)

  interface operator (.ne.)
    module procedure kim_model_create_handle_not_equal
  end interface operator (.ne.)

  interface kim_set_model_numbering
    module procedure kim_model_create_set_model_numbering
  end interface kim_set_model_numbering

  interface kim_set_influence_distance_pointer
    module procedure kim_model_create_set_influence_distance_pointer
  end interface kim_set_influence_distance_pointer

  interface kim_set_neighbor_list_pointers
    module procedure kim_model_create_set_neighbor_list_pointers
  end interface kim_set_neighbor_list_pointers

  interface kim_set_refresh_pointer
    module procedure kim_model_create_set_refresh_pointer
  end interface kim_set_refresh_pointer

  interface kim_set_destroy_pointer
    module procedure kim_model_create_set_destroy_pointer
  end interface kim_set_destroy_pointer

  interface kim_set_compute_arguments_create_pointer
    module procedure kim_model_create_set_compute_arguments_create_pointer
  end interface kim_set_compute_arguments_create_pointer

  interface kim_set_compute_arguments_destroy_pointer
    module procedure kim_model_create_set_compute_arguments_destroy_pointer
  end interface kim_set_compute_arguments_destroy_pointer

  interface kim_set_compute_pointer
    module procedure kim_model_create_set_compute_pointer
  end interface kim_set_compute_pointer

  interface kim_set_species_code
    module procedure kim_model_create_set_species_code
  end interface kim_set_species_code

  interface kim_set_parameter_pointer
    module procedure kim_model_create_set_parameter_pointer_integer
    module procedure kim_model_create_set_parameter_pointer_double
  end interface kim_set_parameter_pointer

  interface kim_set_model_buffer_pointer
    module procedure kim_model_create_set_model_buffer_pointer
  end interface kim_set_model_buffer_pointer

  interface kim_set_units
    module procedure kim_model_create_set_units
  end interface kim_set_units

  interface kim_convert_unit
    module procedure kim_model_create_convert_unit
  end interface kim_convert_unit

  interface kim_log_entry
    module procedure kim_model_create_log_entry
  end interface kim_log_entry

  interface kim_to_string
    module procedure kim_model_create_to_string
  end interface kim_to_string

contains
  logical function kim_model_create_handle_equal(left, right)
    use, intrinsic :: iso_c_binding
    implicit none
    type(kim_model_create_handle_type), intent(in) :: left
    type(kim_model_create_handle_type), intent(in) :: right

    if ((.not. c_associated(left%p)) .and. (.not. c_associated(right%p))) then
      kim_model_create_handle_equal = .true.
    else
      kim_model_create_handle_equal = c_associated(left%p, right%p)
    end if
  end function kim_model_create_handle_equal

  logical function kim_model_create_handle_not_equal(left, right)
    use, intrinsic :: iso_c_binding
    implicit none
    type(kim_model_create_handle_type), intent(in) :: left
    type(kim_model_create_handle_type), intent(in) :: right

    kim_model_create_handle_not_equal = .not. (left .eq. right)
  end function kim_model_create_handle_not_equal

  subroutine kim_model_create_set_model_numbering( &
    model_create_handle, numbering, ierr)
    use, intrinsic :: iso_c_binding
    use kim_numbering_module, only : kim_numbering_type
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      integer(c_int) function set_model_numbering(model_create, &
        numbering) bind(c, name="KIM_ModelCreate_SetModelNumbering")
        use, intrinsic :: iso_c_binding
        use kim_numbering_module, only : kim_numbering_type
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(inout) :: model_create
        type(kim_numbering_type), intent(in), value :: numbering
      end function set_model_numbering
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    type(kim_numbering_type), intent(in), value :: numbering
    integer(c_int), intent(out) :: ierr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    ierr = set_model_numbering(model_create, numbering)
  end subroutine kim_model_create_set_model_numbering

  subroutine kim_model_create_set_influence_distance_pointer( &
    model_create_handle, influence_distance)
    use, intrinsic :: iso_c_binding
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      subroutine set_influence_distance_pointer(model_create, &
        influence_distance) &
        bind(c, name="KIM_ModelCreate_SetInfluenceDistancePointer")
        use, intrinsic :: iso_c_binding
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(inout) :: model_create
        type(c_ptr), intent(in), value :: influence_distance
      end subroutine set_influence_distance_pointer
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    real(c_double), intent(in), target :: influence_distance
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    call set_influence_distance_pointer(model_create, &
      c_loc(influence_distance))
  end subroutine kim_model_create_set_influence_distance_pointer

  subroutine kim_model_create_set_neighbor_list_pointers( &
    model_create_handle, number_of_neighbor_lists, cutoffs, &
    model_will_not_request_neighbors_of_noncontributing_particles)
    use, intrinsic :: iso_c_binding
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      subroutine set_neighbor_list_pointers(model_create, &
        number_of_neighbor_lists, cutoffs_ptr, &
        model_will_not_request_neighbors_of_noncontributing_particles) &
        bind(c, name="KIM_ModelCreate_SetNeighborListPointers")
        use, intrinsic :: iso_c_binding
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(inout) :: model_create
        integer(c_int), intent(in), value :: number_of_neighbor_lists
        type(c_ptr), intent(in), value :: cutoffs_ptr
        type(c_ptr), intent(in), value :: &
          model_will_not_request_neighbors_of_noncontributing_particles
      end subroutine set_neighbor_list_pointers
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    integer(c_int), intent(in), value :: number_of_neighbor_lists
    real(c_double), intent(in), target :: cutoffs(number_of_neighbor_lists)
    integer(c_int), intent(in), target :: &
      model_will_not_request_neighbors_of_noncontributing_particles( &
      number_of_neighbor_lists)
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    call set_neighbor_list_pointers(model_create, number_of_neighbor_lists, &
      c_loc(cutoffs), &
      c_loc(model_will_not_request_neighbors_of_noncontributing_particles))
  end subroutine kim_model_create_set_neighbor_list_pointers

  subroutine kim_model_create_set_refresh_pointer( &
    model_create_handle, language_name, fptr, ierr)
    use, intrinsic :: iso_c_binding
    use kim_language_name_module, only : kim_language_name_type
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      integer(c_int) function set_refresh_pointer(model_create, &
        language_name, fptr) &
        bind(c, name="KIM_ModelCreate_SetRefreshPointer")
        use, intrinsic :: iso_c_binding
        use kim_language_name_module, only : kim_language_name_type
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(inout) :: model_create
        type(kim_language_name_type), intent(in), value :: language_name
        type(c_funptr), intent(in), value :: fptr
      end function set_refresh_pointer
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    type(kim_language_name_type), intent(in), value :: language_name
    type(c_funptr), intent(in), value :: fptr
    integer(c_int), intent(out) :: ierr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    ierr = set_refresh_pointer(model_create, language_name, fptr)
  end subroutine kim_model_create_set_refresh_pointer

  subroutine kim_model_create_set_destroy_pointer(model_create_handle, &
    language_name, fptr, ierr)
    use, intrinsic :: iso_c_binding
    use kim_language_name_module, only : kim_language_name_type
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      integer(c_int) function set_destroy_pointer(model_create, &
        language_name, fptr) &
        bind(c, name="KIM_ModelCreate_SetDestroyPointer")
        use, intrinsic :: iso_c_binding
        use kim_language_name_module, only : kim_language_name_type
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(inout) :: model_create
        type(kim_language_name_type), intent(in), value :: language_name
        type(c_funptr), intent(in), value :: fptr
      end function set_destroy_pointer
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    type(kim_language_name_type), intent(in), value :: language_name
    type(c_funptr), intent(in), value :: fptr
    integer(c_int), intent(out) :: ierr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    ierr = set_destroy_pointer(model_create, language_name, fptr)
  end subroutine kim_model_create_set_destroy_pointer

  subroutine kim_model_create_set_compute_arguments_create_pointer( &
    model_create_handle, language_name, fptr, ierr)
    use, intrinsic :: iso_c_binding
    use kim_language_name_module, only : kim_language_name_type
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      integer(c_int) function set_compute_arguments_create_pointer( &
        model_create, language_name, fptr) &
        bind(c, name="KIM_ModelCreate_SetComputeArgumentsCreatePointer")
        use, intrinsic :: iso_c_binding
        use kim_language_name_module, only : kim_language_name_type
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(inout) :: model_create
        type(kim_language_name_type), intent(in), value :: language_name
        type(c_funptr), intent(in), value :: fptr
      end function set_compute_arguments_create_pointer
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    type(kim_language_name_type), intent(in), value :: language_name
    type(c_funptr), intent(in), value :: fptr
    integer(c_int), intent(out) :: ierr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    ierr = set_compute_arguments_create_pointer(model_create, language_name, &
      fptr)
  end subroutine kim_model_create_set_compute_arguments_create_pointer

  subroutine kim_model_create_set_compute_arguments_destroy_pointer( &
    model_create_handle, language_name, fptr, ierr)
    use, intrinsic :: iso_c_binding
    use kim_language_name_module, only : kim_language_name_type
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      integer(c_int) function set_compute_arguments_destroy_pointer( &
        model_create, language_name, fptr) &
        bind(c, name="KIM_ModelCreate_SetComputeArgumentsDestroyPointer")
        use, intrinsic :: iso_c_binding
        use kim_language_name_module, only : kim_language_name_type
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(inout) :: model_create
        type(kim_language_name_type), intent(in), value :: language_name
        type(c_funptr), intent(in), value :: fptr
      end function set_compute_arguments_destroy_pointer
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    type(kim_language_name_type), intent(in), value :: language_name
    type(c_funptr), intent(in), value :: fptr
    integer(c_int), intent(out) :: ierr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    ierr = set_compute_arguments_destroy_pointer(model_create, language_name, &
      fptr)
  end subroutine kim_model_create_set_compute_arguments_destroy_pointer

  subroutine kim_model_create_set_compute_pointer(model_create_handle, &
    language_name, fptr, ierr)
    use, intrinsic :: iso_c_binding
    use kim_language_name_module, only : kim_language_name_type
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      integer(c_int) function set_compute_pointer(model_create, &
        language_name, fptr) &
        bind(c, name="KIM_ModelCreate_SetComputePointer")
        use, intrinsic :: iso_c_binding
        use kim_language_name_module, only : kim_language_name_type
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(inout) :: model_create
        type(kim_language_name_type), intent(in), value :: language_name
        type(c_funptr), intent(in), value :: fptr
      end function set_compute_pointer
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    type(kim_language_name_type), intent(in), value :: language_name
    type(c_funptr), intent(in), value :: fptr
    integer(c_int), intent(out) :: ierr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    ierr = set_compute_pointer(model_create, language_name, fptr)
  end subroutine kim_model_create_set_compute_pointer

  subroutine kim_model_create_set_species_code(model_create_handle, &
    species_name, code, ierr)
    use, intrinsic :: iso_c_binding
    use kim_species_name_module, only : kim_species_name_type
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      integer(c_int) function set_species_code(model_create, &
        species_name, code) &
        bind(c, name="KIM_ModelCreate_SetSpeciesCode")
        use, intrinsic :: iso_c_binding
        use kim_species_name_module, only : kim_species_name_type
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(in) :: model_create
        type(kim_species_name_type), intent(in), value :: species_name
        integer(c_int), intent(in), value :: code
      end function set_species_code
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    type(kim_species_name_type), intent(in), value :: species_name
    integer(c_int), intent(in), value :: code
    integer(c_int), intent(out) :: ierr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    ierr = set_species_code(model_create, species_name, code)
  end subroutine kim_model_create_set_species_code

  subroutine kim_model_create_set_parameter_pointer_integer( &
    model_create_handle, int1, name, description, ierr)
    use, intrinsic :: iso_c_binding
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    integer(c_int), intent(in), target :: int1(:)
    character(len=*, kind=c_char), intent(in) :: name
    character(len=*, kind=c_char), intent(in) :: description
    integer(c_int), intent(out) :: ierr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    call set_parameter(model_create, size(int1, 1, c_int), int1, name, &
      description, ierr)
    return

  contains
    subroutine set_parameter(model_create, extent, int1, name, description, &
      ierr)
      use, intrinsic :: iso_c_binding
      use kim_interoperable_types_module, only : kim_model_create_type
      implicit none
      interface
        integer(c_int) function set_parameter_pointer_integer( &
          model_create, extent, ptr, name, description) &
          bind(c, name="KIM_ModelCreate_SetParameterPointerInteger")
          use, intrinsic :: iso_c_binding
          use kim_interoperable_types_module, only : kim_model_create_type
          implicit none
          type(kim_model_create_type), intent(inout) :: model_create
          integer(c_int), intent(in), value :: extent
          type(c_ptr), intent(in), value :: ptr
          character(c_char), intent(in) :: name(*)
          character(c_char), intent(in) :: description(*)
        end function set_parameter_pointer_integer
      end interface
      type(kim_model_create_type), intent(inout) :: model_create
      integer(c_int), intent(in), value :: extent
      integer(c_int), intent(in), target :: int1(extent)
      character(len=*, kind=c_char), intent(in) :: name
      character(len=*, kind=c_char), intent(in) :: description
      integer(c_int), intent(out) :: ierr

      ierr = set_parameter_pointer_integer(model_create, extent, &
        c_loc(int1), trim(name)//c_null_char, &
        trim(description)//c_null_char)
    end subroutine set_parameter
  end subroutine kim_model_create_set_parameter_pointer_integer

  subroutine kim_model_create_set_parameter_pointer_double( &
    model_create_handle, double1, name, description, ierr)
    use, intrinsic :: iso_c_binding
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    real(c_double), intent(in), target :: double1(:)
    character(len=*, kind=c_char), intent(in) :: name
    character(len=*, kind=c_char), intent(in) :: description
    integer(c_int), intent(out) :: ierr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    call set_parameter(model_create, size(double1, 1, c_int), double1, &
      name, description, ierr)
    return

  contains
    subroutine set_parameter(model_create, extent, double1, name, description, &
      ierr)
      use, intrinsic :: iso_c_binding
      implicit none
      interface
        integer(c_int) function set_parameter_pointer_double(model_create, &
          extent, ptr, name, description) &
          bind(c, name="KIM_ModelCreate_SetParameterPointerDouble")
          use, intrinsic :: iso_c_binding
          use kim_interoperable_types_module, only : kim_model_create_type
          implicit none
          type(kim_model_create_type), intent(inout) :: model_create
          integer(c_int), intent(in), value :: extent
          type(c_ptr), intent(in), value :: ptr
          character(c_char), intent(in) :: name(*)
          character(c_char), intent(in) :: description(*)
        end function set_parameter_pointer_double
      end interface
      type(kim_model_create_type), intent(inout) :: model_create
      integer(c_int), intent(in), value :: extent
      real(c_double), intent(in), target :: double1(extent)
      character(len=*, kind=c_char), intent(in) :: name
      character(len=*, kind=c_char), intent(in) :: description
      integer(c_int), intent(out) :: ierr

      ierr = set_parameter_pointer_double(model_create, extent, &
        c_loc(double1), trim(name)//c_null_char, &
        trim(description)//c_null_char)
    end subroutine set_parameter
  end subroutine kim_model_create_set_parameter_pointer_double

  subroutine kim_model_create_set_model_buffer_pointer( &
    model_create_handle, ptr)
    use, intrinsic :: iso_c_binding
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      subroutine set_model_buffer_pointer(model_create, ptr) &
        bind(c, name="KIM_ModelCreate_SetModelBufferPointer")
        use, intrinsic :: iso_c_binding
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(inout) :: model_create
        type(c_ptr), intent(in), value :: ptr
      end subroutine set_model_buffer_pointer
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    type(c_ptr), intent(in), value :: ptr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    call set_model_buffer_pointer(model_create, ptr)
  end subroutine kim_model_create_set_model_buffer_pointer

  subroutine kim_model_create_set_units(model_create_handle, &
    length_unit, energy_unit, charge_unit, temperature_unit, time_unit, ierr)
    use, intrinsic :: iso_c_binding
    use kim_unit_system_module, only : &
      kim_length_unit_type, &
      kim_energy_unit_type, &
      kim_charge_unit_type, &
      kim_temperature_unit_type, &
      kim_time_unit_type
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      integer(c_int) function set_units(model_create, length_unit, &
        energy_unit, charge_unit, temperature_unit, time_unit) &
        bind(c, name="KIM_ModelCreate_SetUnits")
        use, intrinsic :: iso_c_binding
        use kim_unit_system_module, only : &
          kim_length_unit_type, &
          kim_energy_unit_type, &
          kim_charge_unit_type, &
          kim_temperature_unit_type, &
          kim_time_unit_type
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(in) :: model_create
        type(kim_length_unit_type), intent(in), value :: length_unit
        type(kim_energy_unit_type), intent(in), value :: energy_unit
        type(kim_charge_unit_type), intent(in), value :: charge_unit
        type(kim_temperature_unit_type), intent(in), value :: temperature_unit
        type(kim_time_unit_type), intent(in), value :: time_unit
      end function set_units
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    type(kim_length_unit_type), intent(in), value :: length_unit
    type(kim_energy_unit_type), intent(in), value :: energy_unit
    type(kim_charge_unit_type), intent(in), value :: charge_unit
    type(kim_temperature_unit_type), intent(in), value :: temperature_unit
    type(kim_time_unit_type), intent(in), value :: time_unit
    integer(c_int), intent(out) :: ierr
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    ierr = set_units(model_create, length_unit, energy_unit, &
      charge_unit, temperature_unit, time_unit)
  end subroutine kim_model_create_set_units

  subroutine kim_model_create_convert_unit( &
    from_length_unit, from_energy_unit, &
    from_charge_unit, from_temperature_unit, from_time_unit, &
    to_length_unit, to_energy_unit, to_charge_unit, to_temperature_unit, &
    to_time_unit, length_exponent, energy_exponent, charge_exponent, &
    temperature_exponent, time_exponent, conversion_factor, ierr)
    use, intrinsic :: iso_c_binding
    use kim_unit_system_module, only : kim_length_unit_type
    use kim_unit_system_module, only : kim_energy_unit_type
    use kim_unit_system_module, only : kim_charge_unit_type
    use kim_unit_system_module, only : kim_temperature_unit_type
    use kim_unit_system_module, only : kim_time_unit_type
    implicit none
    interface
      integer(c_int) function convert_unit( &
        from_length_unit, from_energy_unit, &
        from_charge_unit, from_temperature_unit, from_time_unit, &
        to_length_unit, to_energy_unit, to_charge_unit, to_temperature_unit, &
        to_time_unit, length_exponent, energy_exponent, charge_exponent, &
        temperature_exponent, time_exponent, conversion_factor) &
        bind(c, name="KIM_ModelCreate_ConvertUnit")
        use, intrinsic :: iso_c_binding
        use kim_unit_system_module, only : kim_length_unit_type
        use kim_unit_system_module, only : kim_energy_unit_type
        use kim_unit_system_module, only : kim_charge_unit_type
        use kim_unit_system_module, only : kim_temperature_unit_type
        use kim_unit_system_module, only : kim_time_unit_type
        implicit none
        type(kim_length_unit_type), intent(in), value :: from_length_unit
        type(kim_energy_unit_type), intent(in), value :: from_energy_unit
        type(kim_charge_unit_type), intent(in), value :: from_charge_unit
        type(kim_temperature_unit_type), intent(in), value :: &
          from_temperature_unit
        type(kim_time_unit_type), intent(in), value :: from_time_unit
        type(kim_length_unit_type), intent(in), value :: to_length_unit
        type(kim_energy_unit_type), intent(in), value :: to_energy_unit
        type(kim_charge_unit_type), intent(in), value :: to_charge_unit
        type(kim_temperature_unit_type), intent(in), value :: &
          to_temperature_unit
        type(kim_time_unit_type), intent(in), value :: to_time_unit
        real(c_double), intent(in), value :: length_exponent
        real(c_double), intent(in), value :: energy_exponent
        real(c_double), intent(in), value :: charge_exponent
        real(c_double), intent(in), value :: temperature_exponent
        real(c_double), intent(in), value :: time_exponent
        real(c_double), intent(out) :: conversion_factor
      end function convert_unit
    end interface
    type(kim_length_unit_type), intent(in), value :: from_length_unit
    type(kim_energy_unit_type), intent(in), value :: from_energy_unit
    type(kim_charge_unit_type), intent(in), value :: from_charge_unit
    type(kim_temperature_unit_type), intent(in), value :: from_temperature_unit
    type(kim_time_unit_type), intent(in), value :: from_time_unit
    type(kim_length_unit_type), intent(in), value :: to_length_unit
    type(kim_energy_unit_type), intent(in), value :: to_energy_unit
    type(kim_charge_unit_type), intent(in), value :: to_charge_unit
    type(kim_temperature_unit_type), intent(in), value :: to_temperature_unit
    type(kim_time_unit_type), intent(in), value :: to_time_unit
    real(c_double), intent(in), value :: length_exponent
    real(c_double), intent(in), value :: energy_exponent
    real(c_double), intent(in), value :: charge_exponent
    real(c_double), intent(in), value :: temperature_exponent
    real(c_double), intent(in), value :: time_exponent
    real(c_double), intent(out) :: conversion_factor
    integer(c_int), intent(out) :: ierr

    ierr = convert_unit(from_length_unit, &
      from_energy_unit, from_charge_unit, from_temperature_unit, &
      from_time_unit, to_length_unit, to_energy_unit, to_charge_unit, &
      to_temperature_unit, to_time_unit, length_exponent, energy_exponent, &
      charge_exponent, temperature_exponent, time_exponent, conversion_factor)
  end subroutine kim_model_create_convert_unit

  subroutine kim_model_create_log_entry(model_create_handle, log_verbosity, &
    message)
    use, intrinsic :: iso_c_binding
    use kim_log_verbosity_module, only : kim_log_verbosity_type
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      subroutine log_entry(model_create, log_verbosity, message, line_number, &
        file_name) bind(c, name="KIM_ModelCreate_LogEntry")
        use, intrinsic :: iso_c_binding
        use kim_log_verbosity_module, only : kim_log_verbosity_type
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(in) :: model_create
        type(kim_log_verbosity_type), intent(in), value :: log_verbosity
        character(c_char), intent(in) :: message(*)
        integer(c_int), intent(in), value :: line_number
        character(c_char), intent(in) :: file_name(*)
      end subroutine log_entry
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    type(kim_log_verbosity_type), intent(in), value :: log_verbosity
    character(len=*, kind=c_char), intent(in) :: message
    type(kim_model_create_type), pointer :: model_create

    call c_f_pointer(model_create_handle%p, model_create)
    call log_entry(model_create, log_verbosity, trim(message)//c_null_char, &
      0, ""//c_null_char)
  end subroutine kim_model_create_log_entry

  subroutine kim_model_create_to_string(model_create_handle, string)
    use, intrinsic :: iso_c_binding
    use kim_convert_string_module, only : kim_convert_string
    use kim_interoperable_types_module, only : kim_model_create_type
    implicit none
    interface
      type(c_ptr) function model_create_string(model_create) &
        bind(c, name="KIM_ModelCreate_String")
        use, intrinsic :: iso_c_binding
        use kim_interoperable_types_module, only : kim_model_create_type
        implicit none
        type(kim_model_create_type), intent(in) :: model_create
      end function model_create_string
    end interface
    type(kim_model_create_handle_type), intent(in) :: model_create_handle
    character(len=*, kind=c_char), intent(out) :: string
    type(kim_model_create_type), pointer :: model_create

    type(c_ptr) :: p

    call c_f_pointer(model_create_handle%p, model_create)
    p = model_create_string(model_create)
    if (c_associated(p)) then
      call kim_convert_string(p, string)
    else
      string = ""
    end if
  end subroutine kim_model_create_to_string
end module kim_model_create_module
