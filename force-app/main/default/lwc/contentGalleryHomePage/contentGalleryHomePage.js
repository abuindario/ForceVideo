import {LightningElement, wire, track} from 'lwc';
import getAllContent from '@salesforce/apex/ContenidoSelector.getAllContent';
import { NavigationMixin } from 'lightning/navigation'

export default class ContentGalleryHomePage extends NavigationMixin(LightningElement) {
    @track contentId = new Array();

    @wire(getAllContent)
    wiredContent({error, data}) {
        if(data) {
            for (const [key, value] of Object.entries(data)) {
                this.contentId.push(`${value.Id}`);
                // console.log(Object.keys(data[0]));
            }
            // console.log('ContentId: ' + this.contentId)
        } else if(error) {
            this.myError = error;
        }
    }

    @track selection;

    handleSelection(event) {
        this.selection = event.detail;
        // console.log('Padre recibe: ' + this.selection)
        this[NavigationMixin.GenerateUrl]({
            type: "standard__recordPage",
            attributes: {
                recordId: event.detail,
                objectApiName: 'Content__c',
                actionName: 'view'
            }
        }).then(url => {
            window.open(url, "_blank");
        });
    }
}