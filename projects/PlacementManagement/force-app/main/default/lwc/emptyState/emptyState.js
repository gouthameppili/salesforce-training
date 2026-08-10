import { LightningElement, api } from 'lwc';

export default class EmptyState extends LightningElement {

    @api title = 'No Records Found';

    @api message = 'There is nothing to display.';

}