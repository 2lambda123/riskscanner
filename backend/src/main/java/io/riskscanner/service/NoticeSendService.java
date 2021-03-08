package io.riskscanner.service;

import io.riskscanner.base.domain.MessageDetail;
import io.riskscanner.commons.utils.NoticeConstants;
import io.riskscanner.process.MailNoticeSender;
import io.riskscanner.process.NoticeModel;
import io.riskscanner.process.NoticeSender;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.List;

@Component
public class NoticeSendService {
    @Resource
    private MailNoticeSender mailNoticeSender;
    @Resource
    private NoticeService noticeService;

    private NoticeSender getNoticeSender(MessageDetail messageDetail) {
        NoticeSender noticeSender = null;
        switch (messageDetail.getType()) {
            case NoticeConstants.Type.EMAIL:
                noticeSender = mailNoticeSender;
                break;
            default:
                break;
        }

        return noticeSender;
    }

    public void send(String taskType, NoticeModel noticeModel) {
        List<MessageDetail> messageDetails;
        switch (taskType) {
            case NoticeConstants.Mode.API:
                messageDetails = noticeService.searchMessageByType(NoticeConstants.TaskType.RESOURCE_TASK);
                break;
            case NoticeConstants.Mode.SCHEDULE:
                messageDetails = noticeService.searchMessageByResourceId(noticeModel.getResourceId());
                break;
            default:
                messageDetails = noticeService.searchMessageByType(taskType);
                break;
        }
        messageDetails.forEach(messageDetail -> {
            if (StringUtils.equals(messageDetail.getEvent(), noticeModel.getEvent())) {
                this.getNoticeSender(messageDetail).send(messageDetail, noticeModel);
            }
        });
    }
}
