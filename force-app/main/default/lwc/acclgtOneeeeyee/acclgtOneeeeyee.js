import { LightningElement, track} from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Account_OBJECT from '@salesforce/schema/Account';
import {NavigationMixin} from 'lightning/navigation';
export default class SampleControllerLWC extends NavigationMixin(LightningElement) {
    @track accountRecord = {};

    handleFieldChange(e) {
        this.accountRecord[e.currentTarget.fieldName] = e.target.value;
    }

    

    saveForm() {
        
        createRecord({ apiName: Account_OBJECT.objectApiName, fields: this.accountRecord })
            .then(Account => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Account created from saveForm => ' + Account.id,
                        variant: 'success'
                    })
                );
                location.reload();
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
           /*  this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Account',
                    actionName: 'list'
                },
                state:{
                    filterName:'Recent'
                }
            });*/
    }
}