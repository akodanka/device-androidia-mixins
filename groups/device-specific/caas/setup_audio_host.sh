#!/bin/bash
ALSA_CONF="/etc/modprobe.d/alsa-base.conf"

function getCpuInfo {
        echo `lscpu | grep $1 | cut -d ":" -f2 | xargs`
}

function enableHeadset {
        if [[ -z `grep 'dell-headset-multi' $ALSA_CONF` ]];then
                echo "will use dell-headset-multi model for snd-hda-intel"
                echo "options snd-hda-intel model=dell-headset-multi" >> $ALSA_CONF
        fi
}

function setMicGain {
        echo "set alsa mic gain to $1%"
        val=`pactl set-source-volume alsa_input.pci-0000_00_1f.3.analog-stereo $1%`
}

cpu_family=$(getCpuInfo 'family:')
cpu_model=$(getCpuInfo 'Model:')
#Additional param for CML NUC
if [[ ($cpu_family = 6) && ($cpu_model = 166) ]]; then
        echo "CML NUC detected"
        if [[ $1 == "setMicGain" ]]; then
                setMicGain 15
        else
                enableHeadset
        fi
fi

