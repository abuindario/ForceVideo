import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import Id from '@salesforce/schema/Content__c.Id';
import Name from '@salesforce/schema/Content__c.Name';
import Category from '@salesforce/schema/Content__c.Category__c';
import ContentType from '@salesforce/schema/Content__c.Content_type__c';
import url from '@salesforce/schema/Content__c.url_cartel_c__c';

export default class ContentTile extends LightningElement {
    @api content;
    error;
    
    contentRecord;
    id = Id;
    name = Name;
    cat = Category;
    type = ContentType;
    uri = url;

    @wire(getRecord, { recordId: '$content', fields: [ Id, Name, Category, ContentType, url ]})
    wiredContent ({error, data}) {
        if(data) {
            this.contentRecord = data;
            // console.log('KEYS ' + Object.keys(this.contentRecord))
            // console.log('FIELDS KEYS ' + Object.keys(this.contentRecord.fields));
            this.id = this.contentRecord.fields.Id.value;
            this.name = this.contentRecord.fields.Name.value;
            this.cat = this.contentRecord.fields.Category__c.value;
            this.type = this.contentRecord.fields.Content_type__c.value;
            this.uri = this.contentRecord.fields.url_cartel_c__c.value;
            this.selection = this.id;
        } else if (error) {
            console.log('Errores recibidos ' + error);
            this.error = error;
        }
    }

    get backgroundimg() {
        return `background-image: url('${this.uri}');
                -moz-background-size: 100% 100%; /*Firefox 3.6*/
                -o-background-size: 100% 100%; /*opera*/
                -webkit-background-size: 100% 100%; /*Safari*/
                background-size: 100% 100%;`;
    }
    
    @track selection;

    handleSelection(event) {
        // console.log('HIJO select: ' + this.name + ', ID: ' + this.id);
        this.dispatchEvent(new CustomEvent('contselected', {
            detail: this.selection 
        }));
    }

}