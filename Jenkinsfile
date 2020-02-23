def lambdafunc=[]
def commitedfiles =[]
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
        lines.each { String line ->
        commitedfiles.add("${line}")   
        }
        for (item in commitedfiles) {
            String second = item.split("/")[1]
            lambdafunc.push("${second}")
        }
    }
    stage('Build'){
        lambdafunc.forEach {
            sh "zip ${it}-${commitID()}.zip .git/${it}/index.py"
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
    sh 'git rev-parse HEAD > .git/commitID'
    def commitID = readFile('.git/commitID').trim()
    sh 'rm .git/commitID'
    commitID
}


