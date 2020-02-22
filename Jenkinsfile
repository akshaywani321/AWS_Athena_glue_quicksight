if ( checkFolderForDiffs('Lambda/') ) {
    node('slaves'){
        stage('Checkout'){
            checkout([ 
                $class: 'GitSCM', 
                branches: [[name: '*/master']], 
                doGenerateSubmoduleConfigurations: false, 
                extensions:[$class: 'SparseCheckoutPaths', sparseCheckoutPaths: [[path: '/Lambda']]]], 
                submoduleCfg: [], 
                userRemoteConfigs: [[credentialsId: '<gitCredentials>', 
                url: '<gitRepoURL>'
                ]] 
            ])
        }
        stage('Build'){
            steps {
                script {
                    lambdafunc.forEach {
                        stage (${it}) {
                            timestamps{
                                sh 'GOOS=linux go build -o main main.go'
                                sh "zip ${commitID()}.zip main"
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

def getUpdateList(commitid){
    sh "git diff-tree --no-commit-id --name-only -r ${commitid} >> /var/log/changeset"
    def commitedfiles = readFile('/var/log/changeset').split('\n')
    def lambdafunc=[]
    for(int i = 0;i<commitedfiles.size;i++) {
        lambdafunc.add(commitedfiles.tokenize("/")[1]​)
    }
    sh 'rm /var/log/changeset'
    lambdafunc
}

