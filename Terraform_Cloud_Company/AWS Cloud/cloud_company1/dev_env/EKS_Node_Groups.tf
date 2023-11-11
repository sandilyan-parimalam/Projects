resource "aws_eks_node_group" "dev_web_eks_node_group" {
  node_group_name = var.dev_web_eks_node_group
  subnet_ids      = [aws_subnet.dev_web_subnet.id]
  cluster_name    = aws_eks_cluster.dev_web_eks_cluster.name

  scaling_config {
    desired_size = "1"
    min_size     = "1"
    max_size     = "2"
  }
  capacity_type          = "ON_DEMAND"
  #node_group_name_prefix = "dev_web_eks_node_"
  node_role_arn          = aws_iam_role.dev_web_eks_node_iam_role.arn

}