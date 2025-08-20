pipeline {
  agent any

  parameters {
    choice(
      name: 'ACTION',
      choices: ['apply', 'destroy_budget', 'rmstate_budget'],
      description: 'apply = create VMSS + Budget; destroy_budget = delete only budget in Azure; rmstate_budget = remove budget from state only'
    )
  }

  environment {
    ARM_CLIENT_ID       = 'a23c9c1b-273b-4dfd-bd59-8d01d0438578'
    ARM_CLIENT_SECRET   = '-Lp8Q~oFC8JH0AIsw5AhOGmlQdq-ZihXonMNabNj'
    ARM_TENANT_ID       = '66573a45-6f85-4878-bebc-e0bc24647836'
    ARM_SUBSCRIPTION_ID = '5d1b700e-5c37-4a48-a430-e148b56e5404'
    TF_VAR_subscription_id = '5d1b700e-5c37-4a48-a430-e148b56e5404'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Terraform Init and Validate') {
      steps {
        sh '''
          terraform -chdir=terraform init -input=false
          terraform -chdir=terraform fmt -check -diff || true
          terraform -chdir=terraform validate
        '''
      }
    }

    stage('Execute Terraform') {
      steps {
        script {
          if (params.ACTION == 'apply') {
            sh '''
              terraform -chdir=terraform plan -out=tfplan
              terraform -chdir=terraform apply -auto-approve tfplan
            '''
          } else if (params.ACTION == 'destroy_budget') {
            sh '''
              terraform -chdir=terraform destroy -auto-approve -target=azurerm_consumption_budget_subscription.vmss_budget
            '''
          } else if (params.ACTION == 'rmstate_budget') {
            sh '''
              terraform -chdir=terraform state rm azurerm_consumption_budget_subscription.vmss_budget || true
            '''
          }
        }
      }
    }
  }
}
