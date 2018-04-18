<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script src="../../js/general.js"></script>
            <script>
            function AdicionarItems(nametable){
        
                   var count=0;

                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }
                         
                     }
                      
                   }

                    if(count==0)
                    {
                       alert('No escogio ningun registro');
                       return false;
                    }
            /*var cantidadadicionar=document.getElementById('cantidadadicionar');
            cantidadadicionar.value=count;*/
            return true;
           }
           function Material(input,f){
               //alert(input.name);
               var elements=document.getElementById(f);                  
               for(var i=0;i<=elements.length-1;i++){
                  //alert(elements[i].value);
                  //var cellsElement=rowsElement[i].cells;
                  //var cel=elements[i];
                  if (elements[i].name==input.name){
                     //alert(input.name);
                     if (elements[i].checked==true){
                       //alert("entrooo"+elements[i+1].value);
                       elements[i+1].disabled=false;
                     }
                     else{
                       
                       /*alert("Seleccione el Personal antes de asignar el Monto.");
                       elements[i].value='';
                       event.returnValue = false;*/
                     }
                  }                      
               }  
              
           }      
           
                                 function cr(){
            var values=document.body.getElementsByTagName('input');
            alert(values.length);
             for(var i=0;i<values.length;i++){
                //if(values[i].type=='text')
                   values[i].disabled=true; 
             
            }
            alert(values.length);
           }
           
       </script>
        </head>
        <body >
            <h:form id="form1"  >
                <h:outputText value="#{ManagedVersionesFormulaMaestra.cargarFormulaMaestraDetalleMrAgregar}"/>
                <div align="center" class="outputText2">
                    <rich:panel headerClass="headerClassACliente" style="width:50%;margin-top:0.3em">
                        <f:facet name="header">
                            <h:outputText value="Datos De La Formula"/>
                        </f:facet>
                        <h:panelGrid columns="3" style="width:auto">
                            <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nombreProdSemiterminado}" styleClass="outputText2" />
                            <h:outputText value="Nro Versión" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.nroVersion}" styleClass="outputText2" />
                            <h:outputText value="Tamaño Lote" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.cantidadLote}" styleClass="outputText2" />
                            <h:outputText value="Area Empresa" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2" />
                            <h:outputText value="Volumen teórico" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '80' || ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '80'||ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:panelGroup rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '80'||ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}">
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.cantidadVolumen} " styleClass="outputText2"  id="cantidadVolumen"/>
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.unidadMedidaVolumen.abreviatura}" styleClass="outputText2" />
                            </h:panelGroup>
                            <h:outputText value="Volumen de dosificado" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}"/>
                            <h:panelGroup rendered="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.areasEmpresa.codAreaEmpresa eq '81'}">
                                <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.cantidadVolumenDeDosificado} "  styleClass="outputText2" id="cantidadVolumenDosificado" />
                            <h:outputText value="#{ManagedVersionesFormulaMaestra.formulaMaestraVersionaBean.componentesProd.unidadMedidaVolumen.abreviatura}" styleClass="outputText2" />
                            </h:panelGroup>
                        </h:panelGrid>
                    </rich:panel>
                    
                    <rich:dataTable value="#{ManagedVersionesFormulaMaestra.formulaMaestraDetalleMRAgregarList}" 
                                    var="data" id="dataMaterialesAgregar"
                                    headerClass="headerClassACliente" style="margin-top:0.5em">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}" onclick="seleccionarRegistro(this)"/>
                        </h:column>
                        
                        <h:column  >
                            <f:facet name="header">
                                <h:outputText value="Material<br><input type='text' onkeyup='buscarCeldaAgregar(this,1)' class='inputText'"  escape="false"/>
                            </f:facet>
                            <h:outputText  value="#{data.materiales.nombreMaterial}" />
                            
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"   />
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" onblur="valorPorDefecto(this);validarMayorIgualACero(this);" styleClass="inputText"  onkeypress="valNum();"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.abreviatura}"  />
                        </h:column>
                       
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Disolucion"  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.tiposAnalisisMaterialReactivoList[1].checked}"/>
                        </h:column>
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Valoracion"  />
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.tiposAnalisisMaterialReactivoList[0].checked}"/>
                        </h:column>
                        
                    </rich:dataTable>
                    <br>
                    <div id="bottonesAcccion" class="barraBotones">
                        <a4j:commandButton  value="Guardar" styleClass="btn"  action="#{ManagedVersionesFormulaMaestra.guardarFormulaMaestraDetalleMRVersion_action}"  
                        onclick="if(!AdicionarItems('form1:dataMaterialesAgregar')){return false;}"
                        oncomplete="if(#{ManagedVersionesFormulaMaestra.mensaje eq '1'}){alert('Se registraron los materiales');var a=Math.random();window.location.href='navegadorFormulaMaestraDetalleMRVersion.jsf?ag='+a;}
                        else{alert('#{ManagedVersionesFormulaMaestra.mensaje}');}"/>
                        <a4j:commandButton value="Cancelar" styleClass="btn" oncomplete="var a=Math.random();window.location.href='navegadorFormulaMaestraDetalleMRVersion.jsf?car='+a;"/>
                    </div>
                    
                    
                </div>
                
                
            </h:form>
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>

            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../../img/load2.gif" />
                </div>
            </rich:modalPanel>
        </body>
    </html>
    
</f:view>

