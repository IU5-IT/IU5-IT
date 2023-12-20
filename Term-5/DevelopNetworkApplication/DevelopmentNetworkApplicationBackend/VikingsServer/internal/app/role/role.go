package role

type Role int

const (
	Buyer Role = iota
	Moderator
	Admin
)
