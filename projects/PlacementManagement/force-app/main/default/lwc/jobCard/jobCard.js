import { LightningElement, api } from 'lwc';

export default class JobCard extends LightningElement {

    @api job;

    handleApply() {

        const event = new CustomEvent('apply', {
            detail: this.job.Id
        });

        this.dispatchEvent(event);

    }

}