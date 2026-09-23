allprojects {
    repositories {
        google()
        mavenCentral()
        // Falls back to JitPack, matching the repo root settings.gradle.kts.
        maven(url = uri("https://jitpack.io")) {
            credentials {
                username = "jp_r9me618aib27fnsqpnfo3i5hg4"
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
