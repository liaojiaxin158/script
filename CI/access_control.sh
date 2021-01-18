#!/bin/bash


set -x

jenkins_dir=$(pwd)
source "${jenkins_dir}"/HiSTBLinux_RELEASE.sh
source "${jenkins_dir}"/AUTO_COMPILE_RELEASE.sh
source "${jenkins_dir}"/HiSTBLinuxV100R005C00_fossid.sh

source "${jenkins_dir}"/hi3796mv200/Hi3796MV200_APPLOADER_BUILD.sh
source "${jenkins_dir}"/hi3796mv200/Hi3796MV200_BUILD_64bit.sh
source "${jenkins_dir}"/hi3796mv200/Hi3796MV200_BUILD.sh
source "${jenkins_dir}"/hi3796mv200/Hi3796MV200_NAGRA_64BIT.sh
source "${jenkins_dir}"/hi3796mv200/Hi3796MV200_NAGRA_BUILD.sh
source "${jenkins_dir}"/hi3796mv200/Hi3796MV200_TEE_BUILD.sh
#source "${jenkins_dir}"/hi3796mv200/Hi3796MV200_OPTEE_BUILD.sh
source "${jenkins_dir}"/hi3796mv200/Hi3796MV200_IRDETO_BUILD.sh
source "${jenkins_dir}"/hi3796mv200/Hi3796MV200_VMX_ULTRA.sh
source "${jenkins_dir}"/hi3796mv200/Hi3796MV200_NAGRA_APPLOADER_BUILD.sh

source "${jenkins_dir}"/hi3798mv200/Hi3798MV200_VMX_ULTRA.sh
source "${jenkins_dir}"/hi3798mv200/Hi3798MV200_BUILD.sh
source "${jenkins_dir}"/hi3798mv200/Hi3798MV200_BUILD_64bit.sh
source "${jenkins_dir}"/hi3798mv200/Hi3798MV200_BUILD_64bit_tee.sh
source "${jenkins_dir}"/hi3798mv200/Hi3798MV200_BUILD_FASTPLAY.sh
source "${jenkins_dir}"/hi3798mv200/Hi3798MV200_IRDETO_BUILD.sh

source "${jenkins_dir}"/hi3798mv300/HI3798MV300_BUILD.sh
source "${jenkins_dir}"/hi3798mv300/Hi3798MV300_BUILD_TEE.sh
source "${jenkins_dir}"/hi3798mv300/HI3798MV300_FASTPLAY_BUILD.sh

source "${jenkins_dir}"/hi3798cv200/Hi3798CV200_BUILD.sh
source "${jenkins_dir}"/hi3798cv200/Hi3798CV200_VMX_BUILD.sh
source "${jenkins_dir}"/hi3798cv200/Hi3798CV200_TEE_BUILD.sh
source "${jenkins_dir}"/hi3798cv200/Hi3798CV200_FASTPLAY_BUILD.sh

source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_APPLOADER_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_NAGRA_DEBUG_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_NAGRA_RELEASE_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_CONAX_RELEASE_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_EMBEDDED_IRDETO_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_EMBEDDED_LITE_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_EMBEDDED_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMB_EMBEDDED_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMB_IRDETO_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_PVR_V2_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMB_LITE_DEBUG_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_CONAX_DEBUG_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_CONAX_LITE_DEBUG_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_CONAX_LITE_RELEASE_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMA_NAGRA_APPLOADER_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMB_CONAX_DEBUG_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMB_NAGRA_DEBUG_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716MV43DMD_DONGLE_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716mv43NFPGA_BUILD.sh
source "${jenkins_dir}"/hi3716mv430/Hi3716mv43NFPGA_SYNAMEDIA_DEBUG_BUILD.sh

source "${jenkins_dir}"/hi3798mv310/Hi3798MV310_BUILD.sh
source "${jenkins_dir}"/hi3798mv310/Hi3798MV310_TEE_BUILD.sh


source "${jenkins_dir}"/test_platform/Hi3716MV450_BUILD_PLATFORM.sh
source "${jenkins_dir}"/test_platform/Hi3716MV450_TEE_BUILD_PLATFORM.sh
source "${jenkins_dir}"/test_platform/Hi3716MV430_BUILD_PLATFORM.sh
source "${jenkins_dir}"/test_platform/Hi3796MV200_BUILD_PLATFORM.sh
source "${jenkins_dir}"/test_platform/Hi3796MV200_TEE_BUILD_PLATFORM.sh
source "${jenkins_dir}"/test_platform/Hi3798MV200_BUILD_PLATFORM.sh
source "${jenkins_dir}"/test_platform/Hi3798MV200_TEE_BUILD_PLATFORM.sh
source "${jenkins_dir}"/test_platform/Hi3798MV310_BUILD_PLATFORM.sh
source "${jenkins_dir}"/test_platform/Hi3798MV310_TEE_BUILD_PLATFORM.sh

source "${jenkins_dir}"/hi3561mv100/Hi3561MV1DMA_BUILD.sh

function globle_init()
{

    git config --global pack.windowMemory "1000m"
    git config --global pack.packSizeLimit "1000m"
    git config --global pack.threads "1"

    ls -l
    pwd
    date
    ifconfig
    DATE=$(date +%Y%m%d%H%M)
    set +x
    echo "==============Memory Info==============="
    free -g
    echo "=============CPU Info================="
    cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
    echo "======================================="
    set -x
}

function cleanAndUpdateBranchRepository()
{
    if [ $# -lt 1 ] ; then
        echo  "Please input 1 parameter"
        echo "\t$0 project_dir "
        exit 1
    fi

    local project_dir="$1"
    local flag=0
    if [ $# -lt 2 ] ; then
        local branch=linux_master
    else
        local branch="$2"
    fi

    cd "${project_dir}"
    #repo forall -c 'git clean -xdf' && repo forall -c 'git checkout'

    #############先确认当前目录是一个有效的repo仓库################
    repo sync -c
    if [ $? -ne 0 ] ; then
        i=1
        while(("$i"<4))
        do
            repo sync -c
            if [ $? -eq 0 ] ; then
                flag=1
                break
            fi
            i=$(($i+1))
            sleep 1
        done
    else
        flag=1
    fi
    echo "flag----$flag"
    #################如果连续4次更新仓库失败，则说明仓库已经损坏，需要删除原始的，重新开始下载仓库################################
    if [ "$flag" -eq 0  ] ; then
        if [ -z "${project_dir}" ]; then
            echo "empty path"
            exit 1
        fi
        rm -rf "${project_dir}"/Code
        rm -rf "${project_dir}"/.repo
        rm -rf "${project_dir}"/CI
        rm -rf "${project_dir}"/build
        rm -rf "${project_dir}"/TestCode
    fi

    if [ ! -d "Code" ]; then
            repo init -u http://xxxxx:8080/HIS/HIS_STB_GIT/HiSTBLinux/manifest.git -b "${branch}" -g synamedia,default
    else
        repo forall -c 'git reset --hard '
        repo forall -c 'git stash clear'
        repo forall -c 'git stash'
    fi

    echo "flag----$flag"
    repo sync -c
    if [ $? -ne 0 ] ; then
        i=1
        while(("$i"<10))
        do
            repo sync
            if [ $? -eq 0 ] ; then
                    flag=1
                break
            fi
            i=$(($i+1))
            sleep 1
        done
    else
        flag=1
    fi

    echo "flag----$flag"
    #################如果连续10次更新仓库都失败，则可能是未知问题，退出shell执行################################
    if [ "$flag" -eq 0 ] ; then
        exit 1
    fi
    ##########################################################################################################

    cd -
#    rm -rf "${project_dir}"/Code/out
}

function repo_download()
{

    if [ $# -lt 4 ] ; then
        echo  "Please input 4 parameters"
        echo "\t$0 project_dir gerrit_project gerrit_change_number gerrit_patchset_number"
        echo "\t$0 /usr1/sdk/workspace/Hi3796MV200_TEST HIS/HIS_STB_GIT/HiSTBLinux/Code 65249 1"
        exit 1
    fi

    local project_dir="$1"
    local gerrit_project="$2"
    local gerrit_change_number="$3"
    local gerrit_patchset_number="$4"
    local cherry_pick_flag=0

    cd "${project_dir}"
    repo download -c "${gerrit_project}" "${gerrit_change_number}"/"${gerrit_patchset_number}"
    if [ $? -ne 0 ] ; then
        i=1
        while(("$i"<4))
        do
            repo download -c "${gerrit_project}" "${gerrit_change_number}"/"${gerrit_patchset_number}"
                if [ $? -eq 0 ] ; then
                    cherry_pick_flag=0
                break
            fi
            i=$(($i+1))
            cherry_pick_flag=1
            sleep 1
        done
    fi

    #################如果连续3次下载此提交失败，则可能是未知问题，退出shell执行################################
    if [ "$cherry_pick_flag" -ne 0 ] ; then
        exit 1
    fi

    cd -
}

#************************************************
#***************$1: changeId*********************
#***************$2: 源码根目录*******************
#************************************************
function download_changeid(){
    if [ $# -lt 2 ] ; then
        echo  "Please input 2 parameter"
        echo "\t$0 changeId project_dir "
        exit 1
    fi
    source /etc/profile
    local changeId="$1"
    local project_dir="$2"
    pushd "${project_dir}/.repo/manifests"
        repo_branch=$(git branch --all |grep "\->"|awk -F"/" '{print $NF}')
    popd
    if [ -f "${project_dir}/Changes.txt" ];then
        rm -rf "${project_dir}"/Changes.txt
    fi

    #ChangeList:当前ChangeId指定的所有修改信息列表
    ChangeNumList=($(ssh -p 29418 phistblinux@xxxxxxxx.com gerrit query status:open --patch-sets change:"${changeId}"|grep "url: http"|awk -F"/" '{print $NF}'))
    ChangePrjList=($(ssh -p 29418 phistblinux@xxxxxxxx.com gerrit query status:open --patch-sets change:"${changeId}"|grep "project: "|awk -F"project: " '{print $NF}'))
    if [ "${#ChangeNumList[@]}" != "0" ] && [ "${#ChangeNumList[@]}" == "${#ChangePrjList[@]}" ];then
        pushd "$project_dir"
            i=0
            while [ "$i" -lt "${#ChangeNumList[@]}" ]
            do
                ChangePatch=$(ssh -p 29418 phistblinux@xxxxxxxx.com gerrit query status:open --patch-sets change:${ChangeNumList["$i"]}|grep "refs/changes/"|awk -F"/" '{print $NF}'|tail -1)
                if [ -z "${ChangePatch}" ];then
                    echo "${ChangePrjList[$i]} ${ChangeNumList[$i]} doesn't found any patch-set"
                    exit 1
                else
                    echo "${ChangePrjList[$i]} ${ChangeNumList[$i]} ${ChangePatch}" >> "${project_dir}"/Changes.txt
                    if [ "${ChangePrjList[$i]}" == "ST/enterprisenetwork/Atlanta/hisi/audiodsp/platform" ] && [ "${repo_branch}" != "br_udp980_audio" ];then
                        i=$[i+1]
                        continue
                    fi
                    echo "downloading ${ChangePrjList[i]} ${ChangeNumList[$i]}/${ChangePatch}"
                    repo download -c ${ChangePrjList["$i"]} ${ChangeNumList["$i"]}/"${ChangePatch}"
                fi
                i=$[i+1]
            done
        popd
    else
        echo "All changeNum number is ${#ChangeNumList[@]}"
        echo "All changePrj number is ${#ChangePrjList[@]}"
        echo "Number is not the same or both zero"
        exit 1
    fi
}

function git_cherrypick()
{

    if [ $# -lt 4 ] ; then
        echo  "Please input 2 parameters"
        echo "\t$0 project_dir gerrit_project gerrit_refspec patch_dir"
        echo "\t$0 /usr1/sdk/workspace/UNSAFE_FUNCTION_AND_CAS_CHECK HIS/HIS_STB_GIT/HiSTBLinux/Code refs/changes/49/65249/1 ./../temp/"
        exit 1
    fi

    local project_dir="$1"
    local gerrit_project="$2"
    local gerrit_refspec="$3"
    local patch_dir="$4"
    local cherry_pick_flag=0

    cd "${project_dir}"/Code

    git fetch http://phistblinux@xxxxxxxx.com:8080/"${gerrit_project}" "${gerrit_refspec}" && git format-patch -1 FETCH_HEAD  -o "${patch_dir}"

    if [ $? -ne 0 ] ; then
        i=1
        while(("$i"<4))
        do
            git fetch http://phistblinux@xxxxxxxx.com:8080/"${gerrit_project}" "${gerrit_refspec}" && git format-patch -1 FETCH_HEAD  -o "${patch_dir}"
            if [ $? -eq 0 ] ; then
                    cherry_pick_flag=0
                break
            fi
            i=$(($i+1))
            cherry_pick_flag=1
            sleep 1
        done
    fi

    #################如果连续3次下载此提交失败，则可能是未知问题，退出shell执行################################
    if [ "$cherry_pick_flag" -ne 0 ] ; then
        exit 1
    fi

    cd -

}

function make_clean()
{
    if [ $# -lt 1 ] ; then
        echo  "Please input 1 parameter"
        echo "\t$0 project_dir "
        exit 1
    fi

    local project_dir="$1"

    cd "${project_dir}"/Code
    source ./env.sh
    make clean -j;rm -rf out
    cd ../TestCode
    make clean -j
}

function build()
{
    if [ $# -lt 2 ] ; then
        echo  "Please input 2 parameter"
        echo "\t$0 project_dir project_name "
        exit 1
    fi

    local project_dir="$1"
    local project_name="$2"
    local sdk_verison="$3"

    #make_clean "${project_dir}"

    case "$project_name" in
        "Hi3796MV200_APPLOADER_BUILD" )
            hi3796mv200_apploader_build "${project_dir}"
            ;;
        "Hi3796MV200_BUILD" )
            hi3796mv200_build "${project_dir}"
            ;;
        "Hi3796MV200_BUILD_64bit" )
            hi3796mv200_build_64bit "${project_dir}"
            ;;
        "Hi3796MV200_NAGRA_64BIT" )
            hi3796mv200_nagra_64bit "${project_dir}"
            ;;
        "Hi3796MV200_NAGRA_BUILD" )
            hi3796mv200_nagra_build "${project_dir}"
            ;;
        "Hi3796MV200_TEE_BUILD" )
            hi3796mv200_tee_build "${project_dir}"
            ;;
        "Hi3796MV200_IRDETO_BUILD" )
            hi3796mv200_irdeto_build "${project_dir}"
            ;;
        "Hi3796MV200_VMX_ULTRA" )
            hi3796mv200_vmx_ultra "${project_dir}"
            ;;
        "Hi3796MV200_NAGRA_APPLOADER_BUILD" )
            hi3796mv200_nagra_apploader_build "${project_dir}"
            ;;
        "Hi3798MV200_VMX_ULTRA" )
            hi3798mv200_vmx_ultra "${project_dir}"
            ;;
        "Hi3798MV200_BUILD" )
            hi3798mv200_build "${project_dir}"
            ;;
        "Hi3798MV200_BUILD_64bit" )
            hi3798mv200_build_64bit "${project_dir}"
            ;;
        "Hi3798MV200_BUILD_64bit_tee" )
            hi3798mv200_build_64bit_tee "${project_dir}"
            ;;
        "Hi3798MV200_BUILD_FASTPLAY" )
            hi3798mv200_build_fastplay "${project_dir}"
            ;;
        "HI3798MV300_BUILD" )
            hi3798mv300_build "${project_dir}"
            ;;
        "Hi3798MV300_BUILD_TEE" )
            hi3798mv300_build_tee "${project_dir}"
            ;;
        "HI3798MV300_FASTPLAY_BUILD" )
            hi3798mv300_fastplay_build "${project_dir}"
            ;;
        "Hi3798MV310_BUILD" )
            hi3798mv310_build "${project_dir}"
            ;;
        "Hi3798MV310_TEE_BUILD" )
            hi3798mv310_tee_build "${project_dir}"
            ;;
        "Hi3798CV200_BUILD" )
            hi3798cv200_build "${project_dir}"
            ;;
        "Hi3798CV200_VMX_BUILD" )
            hi3798cv200_vmx_build "${project_dir}"
            ;;
        "Hi3798CV200_TEE_BUILD" )
            hi3798cv200_tee_build "${project_dir}"
            ;;
        "Hi3798CV200_FASTPLAY_BUILD" )
            hi3798cv200_fastplay_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_APPLOADER_BUILD" )
            hi3716mv43dma_apploader_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_NAGRA_DEBUG_BUILD" )
            hi3716mv43dma_nagra_debug_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_CONAX_RELEASE_BUILD" )
            hi3716mv43dma_conax_release_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_EMBEDDED_IRDETO_BUILD" )
            hi3716mv43dma_embedded_irdeto_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_EMBEDDED_LITE_BUILD" )
            hi3716mv43dma_embedded_lite_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_EMBEDDED_BUILD" )
            hi3716mv43dma_embedded_build "${project_dir}"
            ;;
        "Hi3716MV43DMB_EMBEDDED_BUILD" )
            hi3716mv43dmb_embedded_build "${project_dir}"
            ;;
        "Hi3716MV43DMB_IRDETO_BUILD" )
            hi3716mv43dmb_irdeto_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_PVR_V2_BUILD" )
            hi3716mv43dma_pvr_v2_build "${project_dir}"
            ;;
        "Hi3716MV43DMB_LITE_DEBUG_BUILD" )
            hi3716mv43dmb_lite_debug_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_CONAX_DEBUG_BUILD" )
            hi3716mv43dma_conax_debug_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_CONAX_LITE_DEBUG_BUILD" )
            hi3716mv43dma_conax_lite_debug_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_CONAX_LITE_RELEASE_BUILD" )
            hi3716mv43dma_conax_lite_release_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_NAGRA_APPLOADER_BUILD" )
            hi3716mv43dma_nagra_apploader_build "${project_dir}"
            ;;
        "Hi3716MV43DMB_CONAX_DEBUG_BUILD" )
            hi3716mv43dmb_conax_debug_build "${project_dir}"
            ;;
        "Hi3716MV43DMB_NAGRA_DEBUG_BUILD" )
            hi3716mv43dmb_nagra_debug_build "${project_dir}"
            ;;
        "Hi3716MV43DMA_NAGRA_RELEASE_BUILD" )
            hi3716mv43dma_nagra_release_build "${project_dir}"
            ;;
        "Hi3716MV43DMD_DONGLE_BUILD" )
            hi3716mv43dmd_dongle_build "${project_dir}"
            ;;
        "Hi3798MV200_IRDETO_BUILD" )
            hi3798mv200_irdeto_build "${project_dir}"
            ;;
        "HiSTBLinux_RELEASE" )
            histblinux_release "${project_dir}"
            ;;
#        "Hi3796MV200_OPTEE_BUILD" )
#            hi3796mv200_optee_build "${project_dir}"
#            ;;
        "AUTO_COMPILE_RELEASE" )
            auto_compile_release "${project_dir}"
            ;;
        "Hi3716MV450_BUILD_PLATFORM" )
            hi3716mv450_build_platform "${project_dir}"
            ;;
        "Hi3716MV450_TEE_BUILD_PLATFORM" )
            hi3716mv450_tee_build_platform "${project_dir}"
            ;;
    "Hi3716MV430_BUILD_PLATFORM")
        hi3716mv430_build_platform  "${project_dir}"
            ;;
        "Hi3796MV200_BUILD_PLATFORM" )
            hi3796mv200_build_platform "${project_dir}"
            ;;
        "Hi3796MV200_TEE_BUILD_PLATFORM" )
            hi3796mv200_tee_build_platform "${project_dir}"
            ;;
        "Hi3798MV200_BUILD_PLATFORM" )
            hi3798mv200_build_platform "${project_dir}"
            ;;
        "Hi3798MV200_TEE_BUILD_PLATFORM" )
            hi3798mv200_tee_build_platform "${project_dir}"
            ;;
        "Hi3798MV310_BUILD_PLATFORM" )
            hi3798mv310_build_platform "${project_dir}"
            ;;
        "Hi3798MV310_TEE_BUILD_PLATFORM" )
            hi3798mv310_tee_build_platform "${project_dir}"
            ;;
        "Hi3561MV1DMA_BUILD" )
            hi3561mv1dma_build "${project_dir}"
            ;;
        "Hi3716mv43NFPGA_BUILD" )
            Hi3716mv43NFPGA_BUILD "${project_dir}"
            ;;
        "Hi3716mv43NFPGA_SYNAMEDIA_DEBUG_BUILD" )
            Hi3716mv43NFPGA_SYNAMEDIA_DEBUG_BUILD "${project_dir}"
            ;;
            * )
            echo "maybe you input a wrong projectName"
            ;;
    esac
}
