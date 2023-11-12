resource "aws_eks_cluster" "dev_web_eks_cluster" {
  name = var.dev_web_eks_cluster

  vpc_config {
    subnet_ids = [
      aws_subnet.dev_web_subnet.id,
      aws_subnet.dev_web_subnet_1.id,
    ]
  }
  role_arn = aws_iam_role.dev_web_eks_iam_role.arn
  depends_on = [
    aws_iam_role.dev_web_eks_iam_role,
  ]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.dev_web_eks_cluster} --region ${var.region}"
  }
}