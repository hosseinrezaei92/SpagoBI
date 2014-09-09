/** SpagoBI, the Open Source Business Intelligence suite
 * Copyright (C) 2012 Engineering Ingegneria Informatica S.p.A. - SpagoBI Competency Center
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0, without the "Incompatible With Secondary Licenses" notice. 
 * If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/. **/

/**
 * 
 *     
 *  @author
 *  Monica Franceschini
 */
 
  
Ext.define('Sbi.datamining.UploadPanel', {
	extend: 'Ext.panel.Panel',
	layout: {
		type: 'vbox'
    },
    config:{
		minWidth: 600
		, width: 800
		, border:0
		, style: 'margin-bottom: 10px;'
	},
	executeScriptBtn: null,
	datasetFiles : [],
	itsParent: null,
	command: null,
	
	constructor : function(config) {
		this.initConfig(config||{});

		this.itsParent = config.itsParent;
		this.command = config.command;
		
		this.callParent(arguments);
	},

	initComponent: function() {
		this.callParent();
		
		this.getUploadButtons();
	
	},
	
	uploadFiles: function(form, fName, posItem){
       // var form = formPanelN.items.items[posItem].getForm();
        var thisPanel = this;
		var service = Ext.create("Sbi.service.RestService",{
			url: "dataset"
			,method: "POST"
			,subPath: "loadDataset"
			,pathParams: [fName]
		});
        
             form.submit({
                 url: service.getRestUrlWithParameters(), // a multipart form cannot contain parameters on its main URL;
                 												   // they must POST parameters
                 waitMsg: LN('sbi.dm.execution.load.dataset.wait'),
                 success: function(form, action) {
         			Ext.Msg.show({
      				   title : LN('sbi.dm.execution.msg'),
      				   msg: LN('sbi.dm.execution.load.dataset.ok'),
      				   buttons: Ext.Msg.OK
      				});

         			var file=form.owner.items.items[0].value;
         			file = file.substring(file.lastIndexOf('\\')+1);

         			thisPanel.updateDatasetFile(fName, file);
                 },
                 failure : function (form, action) {
         			Ext.Msg.show({
         				title : LN('sbi.dm.execution.msg'),
       				   msg: action.result.msg,
       				   buttons: Ext.Msg.OK
       				});
                 },
                 scope : this
             });

	},
	
	updateDatasetFile: function(dsName, fileName){
		var thisPanel = this;
		
		var service = Ext.create("Sbi.service.RestService",{
			url: "dataset"
			,subPath: "updateDataset"
			,pathParams: [fileName,dsName]
		});
		
		service.callService(this);
		
		var functionSuccess = function(response){
			var thisPanel = this;
			if(response != null && response.responseText !== undefined && response.responseText !== null && response.responseText !== ''){
				var res = Ext.decode(response.responseText);
				if(res.result != null && res.result == Sbi.settings.datamining.execution.ok){
					//update page content...to be done 
				}
			}
		}
		service.callService(this, functionSuccess);
	},
	
	getUploadButtons: function(){
		
		var thisPanel = this;
		
		var service = Ext.create("Sbi.service.RestService",{
			url: "dataset"
			,pathParams: [this.command]
		});
		
		service.callService(this);
		
		var functionSuccess = function(response){
			var thisPanel = this;
			if(response != null && response.responseText !== undefined && response.responseText !== null && response.responseText !== ''){
				var res = Ext.decode(response.responseText);
				
				if(res && Array.isArray(res)){
					
					for (var i=0; i< res.length; i++){
						
						var dataset = res[i];

						
						//file datasets
						if(dataset.type == Sbi.settings.datamining.execution.fileDataset){
							var fieldLbl = dataset.name;
							
							if(dataset.fileName !== undefined && dataset.fileName != null){
								fieldLbl = dataset.name +' ('+dataset.fileName+')';
							}
							var fileField= Ext.create("Ext.form.field.File",{
						        xtype: 'fileuploadfield',
						        value: 'default',
						        name: dataset.name,
						        fieldLabel: fieldLbl,
						        labelWidth: 150,
						        msgTarget: 'side',
						        allowBlank: false,
						        anchor: '100%',
						        border: 0,
						        labelStyle: 'font-weight: bold; color: #28596A;',
						        buttonText: LN('sbi.dm.execution.upload.btn')
						    });
							
							
							this.fileFormN = Ext.create('Ext.form.Panel', {
							    fileUpload: true,
							    bodyPadding: 5,
							    width: 500,
							    // Fields will be arranged vertically, stretched to full width
							    layout: 'anchor',
							    defaults: {
							        anchor: '100%'
							        
							    },
							    border: 0,
							    // The fields
							    defaultType: 'fileuploadfield',
							    items: [fileField],

							    // Reset and Submit buttons
							    buttons: [{
							        text: LN('sbi.dm.execution.reset.btn'),
							        handler: function() {
							            this.up('form').getForm().reset();
							        }
							    }, {
							        text: LN('sbi.dm.execution.load.btn'),
							        formBind: true, //only enabled once the form is valid
							        disabled: true,	
							        scale: 'small',
							        iconCls:'upload',
							        //handler:  Ext.Function.pass(this.uploadFiles, [this, dataset.name, i]),
							        handler: function() {
							        	this.uploadFiles(this.fileFormN.getForm(),dataset.name, i)
	
							        },
							        scope: this
							    }]
							    , scope: this
							});
							
						    var uploadWin = Ext.create('Ext.Window', {
						        title: dataset.name,
						        width: 500,
						        height: 100,
						        x: 10,
						        y: 100,
						        plain: true,
						        autoDestroy: false,
						        headerPosition: 'right',
						        closeAction:'hide',
						        layout: 'fit',
						        items: [this.fileFormN]
						    });
						    
							var addDsFile= Ext.create('Ext.button.Button', {
					            xtype: 'button',
					            iconCls: 'file_import',
					            text: dataset.name,
					            scale: 'medium',
					            handler: function() {
					            	uploadWin.show();
							    }
					        });
							
							thisPanel.add(addDsFile);
							
						}else if(dataset.type == Sbi.settings.datamining.execution.spagoBIDsDataset){
							
							var datasetField =Ext.create("Ext.form.field.Display", {
						        xtype: 'displayfield',
						        fieldLabel: 'SpagoBI Dataset label',
						        labelStyle: 'font-weight: bold; color: #28596A;',
						        labelWidth: 150,
						        name: dataset.spagobiLabel,
						        value: dataset.spagobiLabel
						    });
							thisPanel.add(datasetField);
						}
						

					}
					
				}
			
			}else{			
				//hides the execution button
				thisPanel.itsParent.executeScriptBtn.hide();
				
			}
		};
		
		service.callService(this, functionSuccess);
	}
	,refreshUploadButtons: function(){
		this.doLayout();
	}
	
});