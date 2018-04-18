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
            <script type="text/javascript" src='../js/general.js' ></script>
            <script type="text/javascript" src='../js/treeComponet.js' ></script> 
            <style type="text/css">
                .codcompuestoprod{
                background-color:#ADD797;
                }.nocodcompuestoprod{
                background-color:#FFFFFF;
                }
                
            </style>
            <script>
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


                        if(confirm('Desea Eliminar el Registro')){
                            if(confirm('Esta seguro de Eliminar el Registro')){
                                
                                return true;
                            }else{
                                return false;
                            }
                        }else{
                            return false;
                        }
                    }
                }
            </script>
        </head>
        <body>
           
            <h:form id="form1"  >
                <div align="center">                    
                        <br><br>                
                    <h:outputText value="#{ManagedComponentesProducto.obtenerCodigoPresentacionesPrimarias}"   />
                    <h3>Presentaciones Primarias</h3>                                        
                    <h:outputText value="#{ManagedComponentesProducto.nombreComProd}" styleClass="outputText2" />
                    <br><br>
                    <rich:dataTable value="#{ManagedComponentesProducto.presentacionesPrimariasList}" var="data" id="dataPresenacionesPrimarias" 
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                                    onRowMouseOver="this.style.backgroundColor='#F3F7FD';" 
                                    headerClass="headerClassACliente"
                                    columnClasses="tituloCampo">
                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value=""  />                                
                            </f:facet>
                            <h:selectBooleanCheckbox value="#{data.checked}"  />                            
                        </rich:column >                        
                        <rich:column >
                            <f:facet name="header">
                                <h:outputText value="Envase Primaria"  />
                            </f:facet>
                            <h:outputText value="#{data.envasesPrimarios.nombreEnvasePrim}"  />
                        </rich:column >                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Cantiad"  />
                            </f:facet>
                            <h:outputText value="#{data.cantidad}"  />
                        </rich:column >
                        
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Tipo Programa Produccion"  />
                            </f:facet>
                            <h:outputText value="#{data.tiposProgramaProduccion.nombreTipoProgramaProd}"  />
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Estado"  />
                            </f:facet>
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
                        </rich:column >
                    </rich:dataTable>       
                    <br>

                    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedComponentesProducto.registrarPresentacionesPrimarias}"/>                    
                    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedComponentesProducto.actionEliminarPresentacionesPrimarias}"  onclick="return eliminar('form1:dataPresenacionesPrimarias');"/>
                    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedComponentesProducto.actionEditarPresentacionesPrimarias}"  />
                    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="#{ManagedComponentesProducto.cancelarPresentacionesPrimarias}" />
                    
                </div>                
            </h:form>
        </body>
    </html>
    
</f:view>

