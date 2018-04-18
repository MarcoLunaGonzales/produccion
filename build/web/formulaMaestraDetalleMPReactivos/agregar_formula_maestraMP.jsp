<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" /> 
            <script src="../js/general.js"></script>
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

                    if(count==0){
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
                
                
                
                <div align="center" class="outputText2">
                    
                    
                    <br><br>
                    Agregar Material Reactivo a :<h:outputText value="#{ManagedFormulaMaestraDetalleMP.nombreComProd}"   />
                    <br/>
                    Tipo Material Reactivo : <h:outputText value="#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMP.tiposMaterialReactivo.nombreTipoMaterialReactivo}"   />
                    <br><br>
                    <table width="27%" align="center" class="outputText2">

                    </table>
                    <br><br>
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleMP.formulaMaestraDetalleMPAdicionarList}"  var="data" id="dataCliente" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 

                                    headerClass="headerClassACliente">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />
                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}" onclick="Material(this,'form1')"  />
                        </h:column>
                        
                        <h:column  >
                            <f:facet name="header">
                                <h:outputText value="Material"  />
                            </f:facet>
                            <h:outputText rendered="#{data.swSi}"  style="background-color: #C5F7C8" value=" #{data.materiales.nombreMaterial}"  />
                            <h:outputText rendered="#{data.swNo}" value="#{data.materiales.nombreMaterial}" />
                        </h:column>
                        <h:column >
                            <f:facet name="header">
                                <h:outputText value="Cantidad"   />
                            </f:facet>
                            <h:inputText value="#{data.cantidad}" styleClass="inputText"  onkeypress="valNum();"/>
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Unidad Medida"  />
                            </f:facet>
                            <h:outputText value="#{data.unidadesMedida.abreviatura}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Fracciones"   />
                            </f:facet>
                            <h:inputText value="#{data.nroPreparaciones}" styleClass="inputText"  onkeypress="valNum();"/>
                        </h:column>
                        
                    </rich:dataTable>
                    <br>
                    <h:commandButton  value="Guardar" styleClass="btn"  action="#{ManagedFormulaMaestraDetalleMP.guardarFormulaMaestraDetalleMR}"   onclick="return AdicionarItems('form1:dataCliente');" />
                    <h:commandButton  value="Cancelar" styleClass="btn" action="#{ManagedFormulaMaestraDetalleMP.cancelarReactivo}"/>
                    
                    
                    
                </div>
                
                
            </h:form>
        </body>
    </html>
    
</f:view>
