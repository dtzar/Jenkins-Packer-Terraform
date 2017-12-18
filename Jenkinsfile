podTemplate(
    label: 'hashicorp',
    containers: [
        containerTemplate(name: 'packer', image: 'hashicorp/packer:1.1.3', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'terraform', image: 'hashicorp/terraform:0.11.1', ttyEnabled: true, command: 'cat')
    ],
    envVars: [
        envVar(key: 'IMAGE_RESOURCE_GROUP_NAME', value: 'apache'),
        envVar(key: 'BUILD_RESOURCE_GROUP_NAME', value: 'apache'),
        envVar(key: 'IMAGE_NAME_PREFIX', value: 'apachecustom'),
        secretEnvVar(key: 'ARM_CLIENT_ID', secretName: 'azuresecrets', secretKey: 'ARM_CLIENT_ID'),
        secretEnvVar(key: 'ARM_CLIENT_SECRET', secretName: 'azuresecrets', secretKey: 'ARM_CLIENT_SECRET'),
        secretEnvVar(key: 'ARM_STORAGE_ACCOUNT', secretName: 'azuresecrets', secretKey: 'ARM_STORAGE_ACCOUNT'),
        secretEnvVar(key: 'ARM_SUBSCRIPTION_ID', secretName: 'azuresecrets', secretKey: 'ARM_SUBSCRIPTION_ID'),
        secretEnvVar(key: 'ARM_TENANT_ID', secretName: 'azuresecrets', secretKey: 'ARM_TENANT_ID'),
        secretEnvVar(key: 'TF_STATE_STORAGE_ACCOUNT', secretName: 'azuresecrets', secretKey: 'TF_STATE_STORAGE_ACCOUNT'),
        secretEnvVar(key: 'TF_STATE_CONTAINER_NAME', secretName: 'azuresecrets', secretKey: 'TF_STATE_CONTAINER_NAME'),
        secretEnvVar(key: 'TF_STATE_ACCESS_KEY', secretName: 'azuresecrets', secretKey: 'TF_STATE_ACCESS_KEY'),
        secretEnvVar(key: 'TF_STATE_KEY', secretName: 'azuresecrets', secretKey: 'TF_STATE_KEY')
    ]
    ) {

    node('hashicorp') {
        stage('Packer CI') {
            git 'https://github.com/dtzar/JenkinsPipeTest.git'
            container('packer') {
                stage('Build Packer Image') {
                    echo "Building $IMAGE_NAME_PREFIX${env.BUILD_ID}"
                    sh """
                    export IMAGE_NAME=$IMAGE_NAME_PREFIX${env.BUILD_ID}
                    packer build ./httpd/httpd.json
                    """
                }
            }
        }

        stage('Terraform CD') {
            git url: 'https://github.com/dtzar/JenkinsPipeTest.git'
            container('terraform') {
                stage('Deploy Packer Image with Terraform') {
                    sh """
                    cd httpd
                    terraform init
                    terraform apply -var 'location=eastus' -var 'packer_image=$IMAGE_NAME_PREFIX${env.BUILD_ID}' -auto-approve
                    """
                }
            }
        }

    }
}
