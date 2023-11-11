resource "aws_route_table_association" "dev_web_rt_association" {
  subnet_id      = aws_subnet.dev_web_subnet.id
  route_table_id = aws_route_table.dev_web_rt.id
}
resource "aws_route_table_association" "dev_web_rt_association_1" {
  subnet_id      = aws_subnet.dev_web_subnet_1.id
  route_table_id = aws_route_table.dev_web_rt.id
}