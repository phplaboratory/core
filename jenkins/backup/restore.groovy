job('madcore.restore') {
    parameters {
        stringParam('S3BucketName', '', 'Input S3 bucket name where backup will be uploaded')
    }
    steps {
        def command = """#!/bin/bash
        sudo /opt/madcore/jenkins/backup/restore.sh "\$S3BucketName"
"""
        shell(command)
    }
}
