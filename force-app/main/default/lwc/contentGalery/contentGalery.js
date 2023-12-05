import { LightningElement, wire, track, api } from 'lwc';
import getContenidoPorCliente from '@salesforce/apex/ContenidoSelector.getContenidoPorCliente';
import { NavigationMixin } from 'lightning/navigation'

export default class ContentGalery extends NavigationMixin(LightningElement) { 
    @api recordId;
    @track contentId = new Array();

    @wire(getContenidoPorCliente, {acctID: "$recordId"})
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

// Crear un LWC contentGalery que use el método getContenidoPorCliente para obtener el
// contenido disponible para una cuenta y lo muestre usando el componente contentTile,
// mostrando una galería de carteles, con 4 por fila. Nota: La composición de la galería (4
// columnas de carteles) se construirá usando el component ‘lightning-layout’.
// • Cuando un cartel sea seleccionado, el componente contentTile debe enviar la Id de dicho
// contenido al componente contentGalery. El componente contentGalery debe abrir la página
// del registro en una pestaña nueva.
// • El componente contentGalery se añadirá a la Lightning Record Page de Cuenta.
// Nota: Cuando un componente es añadido a una record page, se obtendrá dinámicamente el Id
// del registro en el que estamos creando un atributo @api recordId en el componente.