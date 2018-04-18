<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script> 
            <script>
                function getCodigo(cod_maquina,codigo){
                 //  alert(codigo);
                   location='../partes_maquinaria/navegador_partes_maquinaria.jsf?cod_maquina='+cod_maquina+'&codigo='+codigo;
                }
                
                function editarItem(nametable){
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
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }                                      
                }


                function asignar(nametable){

                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    alert('hola');
                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }                         
                     }                      
                   }
                    if(count==0){
                       alert('No selecciono ningun Registro');
                       return false;
                   }else{
                       if(confirm('Desea Asignar como Area Raiz')){
                            if(confirm('Esta seguro de Asignar como Area Raiz')){
                                 return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                   
                   }
                   
                }          
            function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            //alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                    
                }
           }                

           function validarSeleccion(nametable){
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
                   if(count==1){
                      return true;
                   } else if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                   }
                   else if(count>1){
                       alert('Solo puede escoger un registro');
                       return false;
                   }
                }
        function verManteminiento(cod_maquina,codigo){                 
                   location='../partes_maquinaria/navegador_partes_maquinaria.jsf?cod_maquina='+cod_maquina+'&codigo='+codigo;
        }
       </script>
        </head>
        <body >
            <a4j:form id="form1">
                <div align="center">
                    <h:outputText value="#{ManagedFormulaMaestraDetalleFP.cargarContenidoFormulaMaestraDetalleFP}"/>
                    <h:outputText styleClass="outputTextTitulo"  value="Listado de Fases de Formula Maestra" />
                    <br><br>                    
                    <rich:dataTable value="#{ManagedFormulaMaestraDetalleFP.formulaMaestraDetalleFPList}" var="data"
                                    id="dataFormulaMaestraFase"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';" 
                                    headerClass="headerClassACliente" binding="#{ManagedFormulaMaestraDetalleFP.formulaMaestrasDetalleFPDataTable}">
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value=""  />                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Orden"  />
                            </f:facet>
                            <h:outputText value="#{data.ordenFasePreparado}" />
                        </h:column>                        
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Descripcion Fase"  />
                            </f:facet>
                            <h:outputText value="#{data.descripcionFase}" />
                        </h:column>
                        <h:column>
                            <f:facet name="header">
                                <h:outputText value="Actividades de Fase"  />
                            </f:facet>
                            <a4j:commandLink action="#{ManagedFormulaMaestraDetalleFP.verFormulaMaestraDetalleFPActividad_action}" >
                                <h:graphicImage value="../img/organigrama3.jpg" />
                            </a4j:commandLink>
                            <h:outputText value=""  />
                        </h:column>
                    </rich:dataTable>
                    <%-- <ws:datascroller fordatatable="dataAreasEmpresa"  />--%>
                    <br>                    
                    <a4j:commandButton value="Agregar" styleClass="btn" onclick="javascript:Richfaces.showModalPanel('panelAgregarFormulaMaestraFase')" action="#{ManagedFormulaMaestraDetalleFP.agregarFormulaMaestraDetalleFP_action}"
                    reRender="contenidoFrecuenciaMantenimentoMaquinaria" />                    
                    <a4j:commandButton value="Editar"  styleClass="btn" onclick="javascript:if(validarSeleccion('form1:dataFormulaMaestraFase')==false){return false;}else{Richfaces.showModalPanel('panelEditarFormulaMaestraFase')}"  action="#{ManagedFormulaMaestraDetalleFP.editarFormulaMaestraDetalleFP_action}"
                    reRender="contenidoEditarFormulaMaestraFase" />
                    <a4j:commandButton value="Eliminar"  styleClass="btn" onclick="javascript:if(confirm('Esta Seguro de Eliminar??')==false || validarSeleccion('form1:dataFormulaMaestraFase')==false){return false;}"  action="#{ManagedFormulaMaestraDetalleFP.eliminarFormulaMaestraDetalleFP_action}"
                    reRender="dataFormulaMaestraFase"/>
                    <a4j:commandButton styleClass="btn" value="Cancelar" onclick="location='../formulaMaestraPreparado/navegadorFormulaMaestraPreparado.jsf'" />

                </div>
                <!--cerrando la conexion-->
                <h:outputText value="#{ManagedFrecuenciaMantenimientoMaquinaria.closeConnection}"  />
                
            </a4j:form>
            
             <rich:modalPanel id="panelAgregarFormulaMaestraFase" minHeight="150"  minWidth="400"
                                     height="180" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Fases Formula Maestra"/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoAgreagarFaseFormulaMaestra">
                            <h:panelGrid columns="3">
                                <h:outputText value="Orden" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFP.formulaMaestraDetalleFP.ordenFasePreparado}" styleClass="inputText"/>

                                <h:outputText value="Descripcion Fase" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputTextarea value="#{ManagedFormulaMaestraDetalleFP.formulaMaestraDetalleFP.descripcionFase}" styleClass="inputText" rows="3" cols="50" />
                                <%--h:inputText value="#{ManagedFormulaMaestraDetalleFP.formulaMaestraDetalleFP.descripcionFase}" styleClass="inputText" size="" /--%>
                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Registrar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarFormulaMaestraFase');"
                                action="#{ManagedFormulaMaestraDetalleFP.registrarFormulaMaestraDetalleFP_action}" reRender="dataFormulaMaestraFase"
                                                    />                                
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarFormulaMaestraFase')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

            <rich:modalPanel id="panelEditarFormulaMaestraFase" minHeight="150"  minWidth="400"
                                     height="180" width="500"
                                     zindex="200"
                                     headerClass="headerClassACliente"
                                     resizeable="false" style="overflow :auto" >
                        <f:facet name="header">
                            <h:outputText value="Editar Fase Formula Maestra"/>
                        </f:facet>
                        <a4j:form>
                        <h:panelGroup id="contenidoEditarFormulaMaestraFase">
                            <h:panelGrid columns="3">
                                <h:outputText value="Orden" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputText value="#{ManagedFormulaMaestraDetalleFP.formulaMaestraDetalleFP.ordenFasePreparado}" styleClass="inputText"/>

                                <h:outputText value="Descripcion Fase" styleClass="outputText1" />
                                <h:outputText value="::" styleClass="outputText1" />
                                <h:inputTextarea value="#{ManagedFormulaMaestraDetalleFP.formulaMaestraDetalleFP.descripcionFase}" styleClass="inputText" rows="3" cols="50" />
                            </h:panelGrid>
                                <div align="center">
                                <a4j:commandButton styleClass="btn" value="Guardar" onclick="javascript:Richfaces.hideModalPanel('panelEditarFormulaMaestraFase');"
                                action="#{ManagedFormulaMaestraDetalleFP.guardarEdicionFormulaMaestraDetalleFP_action}" reRender="dataFormulaMaestraFase"
                                                    />
                                <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarFormulaMaestraFase')" class="btn" />
                                </div>
                        </h:panelGroup>
                        </a4j:form>
            </rich:modalPanel>

        </body>
    </html>
    
</f:view>

