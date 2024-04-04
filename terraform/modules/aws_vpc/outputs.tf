output "id" {
  value = aws_vpc.local_vpc.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

# output "private_subnets" {
#   value = aws_subnet.private.*.id
# }

output "cidr_block" {
  value = aws_vpc.local_vpc.cidr_block
}

output "route_table_public" {
  value = aws_route_table.public.id
}

# output "route_tables_private" {
#   value = aws_route_table.private.*.id
# }

output "route_table_ids" {
  value = concat([aws_route_table.public.id])

  # Enable when private subnets exists:
  #value = concat([aws_route_table.public.id], aws_route_table.private.*.id)
}
