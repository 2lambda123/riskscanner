package io.riskscanner.base.domain;

import java.util.List;

public class MessageSettingDetail {
    private List<MessageDetail> resources;

    public List<MessageDetail> getResources() {
        return resources;
    }

    public void setResources(List<MessageDetail> resources) {
        this.resources = resources;
    }
}
