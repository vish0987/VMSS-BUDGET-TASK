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
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Init') {
      steps {
        sh 'terraform -chdir=terraform init -input=false'
      }
    }

    stage('Validate') {
      steps {
        sh 'terraform -chdir=terraform fmt -check -diff || true'
        sh 'terraform -chdir=terraform validate'
      }
    }

    stage('Apply (VMSS + Budget)') {
      when { expression { params.ACTION == 'apply' } }
      steps {
        sh '''
          terraform -chdir=terraform plan -out=tfplan
          terraform -chdir=terraform apply -auto-approve tfplan
        '''
      }
    }

    stage('Destroy Budget Only') {
      when { expression { params.ACTION == 'destroy_budget' } }
      steps {
        sh '''
          terraform -chdir=terraform destroy \
            -auto-approve \
            -target=azurerm_consumption_budget_subscription.vmss_budget
        '''
      }
    }

    stage('Remove Budget From State Only') {
      when { expression { params.ACTION == 'rmstate_budget' } }
      steps {
        sh '''
          terraform -chdir=terraform init -input=false
          terraform -chdir=terraform state rm azurerm_consumption_budget_subscription.vmss_budget || true
        '''
      }
    }
  }
}
