pipeline {
agent any
parameters {
choice(name: 'ACTION', choices: ['apply', 'destroy_budget'], description: 'Terraform action')
}
environment {
ARM_CLIENT_ID = credentials('AZURE_SPN_APPID')
ARM_CLIENT_SECRET = credentials('AZURE_SPN_PASSWORD')
ARM_TENANT_ID = credentials('AZURE_SPN_TENANT')
ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
}
stages {
stage('Init') {
steps { dir('terraform') { sh 'terraform init' } }
}
stage('Plan/Apply') {
steps {
dir('terraform') {
script {
if (params.ACTION == 'apply') {
sh 'terraform apply -auto-approve'
} else if (params.ACTION == 'destroy_budget') {
sh 'terraform destroy -target=azurerm_consumption_budget_subscription.budget -auto-approve'
}
}
}
}
}
}
}
