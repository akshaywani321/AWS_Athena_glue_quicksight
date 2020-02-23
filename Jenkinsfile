def lambdafunc=[]
def bucket="smart-hub-scriptstore-571941764095-us-east-1"
def reigon="us-east-1"
node{
    if (checkFolderForDiffs('/Lambda')) {
    stage('Checkout'){
        checkout([$class: 'GitSCM', 
            branches: [[name: '*/master']], 
            doGenerateSubmoduleConfigurations: false, 
            extensions:[[$class: 'SparseCheckoutPaths', sparseCheckoutPaths: [[path: '/Lambda']]]], 
            submoduleCfg: [], 
            userRemoteConfigs: scm.userRemoteConfigs 
        ])
    }
    stage('Initialise')
    {   
        sh "git diff-tree --no-commit-id --name-only -r ${commitID()} >> .git/changeset"
        def lines = readFile('.git/changeset').readLines()
        lines.each{line ->
            if (line.contains('Lambda/') && line.contains('/index.py')){
                println(line)
                second = line.split("/")[1] as String
                lambdafunc.push("${second}")
            }
        }
        sh 'rm .git/changeset'
    }
    stage('Build'){
        lambdafunc.each {
            sh "zip -r -D .git/function.zip Lambda/${it}/index.py"
        } 
    }
    stage('Push'){
        lambdafunc.each {
            sh "aws s3 cp .git/function.zip s3://${bucket}/${it}/"
        }
    }
    stage('Deploy'){
        lambdafunc.each {
        sh "aws lambda update-function-code --function-name ${it} \
                --s3-bucket ${bucket} \
                --s3-key ${it}/function.zip \
                --region ${reigon}"
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
    sh 'git rev-parse HEAD > .git/commitID'
    def commitID = readFile('.git/commitID').trim()
    sh 'rm .git/commitID'
    commitID
}