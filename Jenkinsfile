podTemplate(label: 'hashicorp', containers: [
    containerTemplate(name: 'packer', image: 'hashicorp/packer:1.1.3', ttyEnabled: true, command: 'cat'),
    containerTemplate(name: 'terraform', image: 'hashicorp/terraform:0.11.1', ttyEnabled: true, command: 'cat')
  ]) {

    node('hashicorp') {
        stage('Get Packer Source Code') {
            git 'https://github.com/dtzar/JenkinsPipeTest.git'
            container('packer') {
                stage('Build Packer Image') {
                    sh 'packer -v'
                }
            }
        }

        stage('Get Terraform Source Code') {
            git url: 'https://github.com/dtzar/JenkinsPipeTest.git'
            container('terraform') {
                stage('Deploy Packer Image with Terraform') {
                    sh """
                    terraform -v
                    """
                }
            }
        }

    }
}