def lambdafunc=[]
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
            if (line.contains('Lambda/')){
                println(line)
                second = line.split("/")[1] as String
                lambdafunc.push("${second}")
            }
        }
        sh 'rm .git/changeset'
    }
    stage('Build'){
        lambdafunc.each {
            sh "zip .git/${it}-${commitID()}.zip Lambda/${it}/index.py"
        } 
    }
    stage('Push'){
        lambdafunc.each {
            sh "aws s3 cp .git/${it}-${commitID()}.zip s3://Lambda/smart-hub-scriptstore-571941764095-us-east-1/${it}/"
        }
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
    sh 'git rev-parse HEAD > .git/commitID'
    def commitID = readFile('.git/commitID').trim()
    sh 'rm .git/commitID'
    commitID
}


