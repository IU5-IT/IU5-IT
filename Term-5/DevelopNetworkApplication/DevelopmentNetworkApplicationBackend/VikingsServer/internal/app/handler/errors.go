package handler

import "errors"

var (
	idNotFound                                    = errors.New("param `id` not found")
	idMustBeEmpty                                 = errors.New("param `id` must be empty")
	cityCannotBeEmpty                             = errors.New("city name cannot be empty")
	headerNotFound                                = errors.New("no file uploaded")
	destinationOrCityIsEmpty                      = errors.New("destination or city cannot be empty")
	serialNumberCannotBeEmpty                     = errors.New("param `serial_number` cannot be empty")
	serialNumberAndDestinationHikeIDCannotBeEmpty = errors.New("param `serial_number` and `destination_hikeI_id` cannot be empty")
	mustBeJustStatus                              = errors.New("must be only `status_id`")
	tokenIsNil                                    = errors.New("token is nil")
	cannotCreateToken                             = errors.New("cannot create str token")
	prefixIsNil                                   = errors.New("prefix not found")
)
