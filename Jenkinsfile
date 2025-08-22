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
    ARM_CLIENT_ID       = '4c0cbcda-a1c2-4fd6-a648-fb6d9e8105db'
    ARM_CLIENT_SECRET   = 'Fl~8Q~XAeGDrv2R7Bw3gTvyhnZfPBs~66n1B_cSS'
    ARM_TENANT_ID       = 'abdf28ce-79b2-47ac-a65f-9fb7e0d74d52'
    ARM_SUBSCRIPTION_ID = '32606fc9-26e6-41a5-95ca-5bd38e7b7974'
    TF_VAR_subscription_id = '/subscriptions/32606fc9-26e6-41a5-95ca-5bd38e7b7974'
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
