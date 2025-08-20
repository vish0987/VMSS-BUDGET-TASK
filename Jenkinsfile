pipeline {
  agent any

  parameters {
    choice(
      name: 'ACTION',
      choices: ['apply', 'destroy_budget', 'rmstate_budget'],
      description: 'apply = create VMSS + Budget; destroy_budget = delete only budget in Azure; rmstate_budget = remove budget from state only'
    )
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
