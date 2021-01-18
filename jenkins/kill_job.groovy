当jenkins的job过多的时候，会出现中止任务卡顿的情况，要很长时间才能停止，所以借用插件，强制停止
1.说明
参数化构建
job_name:
build_number:
支持批量用,分割
import jenkins.model.*

jobs=job_name.split(",")
build_numbers=build_number.split(",")
for(int index=0;index<jobs.size();index++){
    def c_job_name=jobs[index]
    def c_build_number=build_numbers[index]
    println "处理第["+(index+1)+"]个Job:$c_job_name #$c_build_number"
    def job=Jenkins.getInstance().getItemByFullName(c_job_name)
    if(job==null){
        println "Job Name #"+c_job_name+"不存在！"
        continue
    }
    
    def build = job.getBuildByNumber(c_build_number.toInteger())
    if(build==null){
        println "$c_job_name[$c_build_number]不存在！"
        continue
    }
    
    if(build.isBuilding()){
        try{
            if(job instanceof org.jenkinsci.plugins.workflow.job.WorkflowJob){
                build.doKill()    
            }else{
                build.doStop()        
            }
        }catch(Exception e){
            print e.message
        }
    	
    }else{
    	println "Cannot kill state of no building!"
    }
    
}
可能会出现的问题
因为涉及到获取jenkins的参数，可能会存在权限的问题
处理点击Manage Jenkins-->In-process scriptApproval 
method hudson.model.AbstractBuild doStop
method hudson.model.Job getBuildByNumber int
method hudson.model.Run isBuilding
method jenkins.model.Jenkins getItemByFullName java.lang.String
staticMethod jenkins.model.Jenkins getInstance
相关jenkins插件:
Job Configuration History
Localization: Chinese (Simplified)
Log Parser Plugin
Python Plugin
SSH Agent Plugin
Script Security Plugin
Gerrit Trigger
export dynamic job data
https://segmentfault.com/a/1190000021513223
Jenkins build failure analyzer plugin
