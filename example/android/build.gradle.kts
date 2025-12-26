allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = file("../build")

subprojects {
    afterEvaluate { project ->
        project.extensions.findByType<com.android.build.gradle.BaseExtension>()?.let { android ->
            if (android.namespace == null) {
                android.namespace = project.group?.toString()
            }
        }
    }
}

subprojects {
    project.buildDir = file("${rootProject.buildDir}/${project.name}")
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete::class) {
    delete(rootProject.layout.buildDirectory)
}

