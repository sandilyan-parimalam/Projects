resource "aws_iam_role" "dev_web_eks_iam_role" {
  name = var.dev_web_eks_iam_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
}

resource "aws_iam_policy_attachment" "dev_web_eks_iam_policy_attachment" {
  name       = var.dev_web_eks_iam_policy_attachment
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  roles      = [aws_iam_role.dev_web_eks_iam_role.name]
  depends_on = [aws_iam_role.dev_web_eks_iam_role]
}

resource "aws_iam_role" "dev_web_eks_node_iam_role" {
  name = var.dev_web_eks_node_iam_role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com",
        },
        Action = "sts:AssumeRole",
      },
    ],
  })
  depends_on = [aws_iam_policy_attachment.dev_web_eks_iam_policy_attachment]
}

resource "aws_iam_policy_attachment" "dev_web_eks_node_iam_policy_attachment" {
  name       = var.dev_web_eks_node_iam_policy_attachment
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  roles      = [aws_iam_role.dev_web_eks_node_iam_role.name]
  depends_on = [aws_iam_role.dev_web_eks_node_iam_role]
}

resource "aws_iam_policy_attachment" "dev_web_eks_node_iam_policy_attachment1" {
  name       = var.dev_web_eks_node_iam_policy_attachment1
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  roles      = [aws_iam_role.dev_web_eks_node_iam_role.name]
  depends_on = [aws_iam_role.dev_web_eks_node_iam_role]
}

resource "aws_iam_policy_attachment" "dev_web_eks_node_iam_policy_attachment2" {
  name       = var.dev_web_eks_node_iam_policy_attachment2
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  roles      = [aws_iam_role.dev_web_eks_node_iam_role.name]
  depends_on = [aws_iam_role.dev_web_eks_node_iam_role]
}

resource "aws_iam_policy_attachment" "dev_web_eks_node_iam_policy_attachment3" {
  name       = var.dev_web_eks_node_iam_policy_attachment3
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  roles      = [aws_iam_role.dev_web_eks_node_iam_role.name]
  depends_on = [aws_iam_role.dev_web_eks_node_iam_role]
}
