import { LightningElement, track } from 'lwc';
    export default class HelloWorld extends LightningElement {
        @track captcha = Math.round((Math.random() * (900000) + 100000));
        @track enterdCaptcha;
        @track showCaptcha = true;
        handleClick()
        {
            var inp =this.template.querySelector("lightning-input");
            var enterdCaptcha =inp.value;
            
            // eslint-disable-next-line eqeqeq
            if(this.captcha == enterdCaptcha){
              // eslint-disable-next-line no-alert
              alert('Verfied !!!!');
              this.showCaptcha = false;
               
            }else{
              // eslint-disable-next-line no-alert
              alert('Wrong Captcha. Please enter it correctlty');
            }
        }
        closeCapctha(){
            this.showCaptcha = false;
        }
        regenerateCaptcha(){
        this.captcha = Math.round((Math.random() * (900000) + 100000));    
        }

    }