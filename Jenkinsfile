def lambdafunc=[]
def commitedfiles =[]
if (checkFolderForDiffs('Lambda/')) {
pipeline {
    agent any
    node('slaves'){
        stage('Checkout'){
            checkout([$class: 'GitSCM', 
                branches: [[name: '*/master']], 
                doGenerateSubmoduleConfigurations: false, 
                extensions:[[$class: 'SparseCheckoutPaths', sparseCheckoutPaths: [[path: '/Lambda']]]], 
                submoduleCfg: [], 
                userRemoteConfigs: [[credentialsId: '<gitCredentials>', url: '<gitRepoURL>']] 
            ])
        }
        stage('Initialise')
        {
            sh "git diff-tree --no-commit-id --name-only -r ${commitID()} >> /var/log/changeset"
            commitedfiles = readFile('/var/log/changeset').split('\n')
            for (item in commitedfiles) {
                String second = item.split("/")[1]
                lambdafunc.push("${second}")
            }
            sh 'rm /var/log/changeset' 
        }
        stage('Build'){
            steps {
                script {
                    lambdafunc.forEach {
                        stage (it) {
                            timestamps{
                                sh "zip ${it}-${commitID()}.zip ./${it}/index.py"
                            }
                        }
                    }
                }
            }
        }
        stage('Push'){
            sh "aws s3 cp ${commitID()}.zip s3://${bucket}"
        }
        stage('Deploy'){
            sh "aws lambda update-function-code --function-name ${functionName} \
                    --s3-bucket ${bucket} \
                    --s3-key ${commitID()}.zip \
                    --region ${region}"
        }
    }
}
}

def checkFolderForDiffs(path) {
    try {
        sh "git diff --quiet --exit-code HEAD~1..HEAD ${path}"
        return false
    } catch (err) {
        return true
    }
}
def commitID() {
    sh 'git rev-parse HEAD > /var/log/commitID'
    def commitID = readFile('/var/log/commitID').trim()
    sh 'rm /var/log/commitID'
    commitID
}


