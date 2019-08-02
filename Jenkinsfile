/*
 * (C) Copyright 2019 Nuxeo (http://nuxeo.com/) and others.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Contributors:
 *     Nelson Silva <nsilva@nuxeo.com>
 */
properties([
  [$class: 'GithubProjectProperty', projectUrlStr: 'https://github.com/nuxeo/nuxeo-web-ui/'],
  [$class: 'BuildDiscarderProperty', strategy: [$class: 'LogRotator', daysToKeepStr: '60', numToKeepStr: '60', artifactNumToKeepStr: '5']],
])

pipeline {
  agent {
    label "jenkins-jx-base"
  }
  environment {
    ORG = 'nuxeo'
    APP_NAME = 'nuxeo-nightly-ui'
  }
  stages {
    stage('Web UI build') {
      steps {
        container('jx-base') {
          script {
            def env = readFile('.env').tokenize('\n'); 
            withEnv(env) {
              if (BRANCH_NAME != 'master') {
                VERSION += "-${BRANCH_NAME}";
              }
              echo """Building nuxeo-nightly-ui:${VERSION}"""
              sh 'envsubst < skaffold.yaml > skaffold.yaml~gen'
              sh 'skaffold build -f skaffold.yaml~gen'
            }
          }
        }
      }
    }
    stage('Deploy Preview') {
      steps {
        container('jx-base') {
          script {
            def env = readFile('.env').tokenize('\n');
            withEnv(env) {
              PREVIEW_NAMESPACE = "$APP_NAME-${BRANCH_NAME.toLowerCase()}-preview"
              dir('charts/preview') {
                sh """
                  kubectl get ns $PREVIEW_NAMESPACE || kubectl create ns $PREVIEW_NAMESPACE
                  kubectl -n webui get secret instance-clid --export -o yaml | kubectl apply -n $PREVIEW_NAMESPACE -f -
                  make preview
                  jx preview --namespace=$PREVIEW_NAMESPACE
                """
              }
            }
          }
        }
      }
    }
  }
}
