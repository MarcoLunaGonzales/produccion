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
    <script>
         function getCodigo(codigo,cod_formula,cod_actividad){
                 //  alert(codigo);
                   location='../maquinaria_actividades_formula/navegador_maq_actividades_formula.jsf?codigo='+codigo+'&cod_formula='+cod_formula+'&cod_actividad='+cod_actividad;
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
<body bgcolor="#F2E7F8">
<h:form id="form1"  >                
<div align="center">                    
    <br>
    <h:outputText value="#{ManagedActividadesProgramaproduccion.obtenerCodigoSeguimiento}" styleClass="outputText2" />
    <h:outputText value="Seguimiento Programa Produccion" styleClass="tituloCabezera1"    />
    <br> <br> <b></b> <h:outputText value="#{ManagedActividadesProgramaproduccion.nombreComProd}"   /></b> 
    <br>
    <br>                          
    <rich:dataTable value="#{ManagedActividadesProgramaproduccion.seguimientoProgramaProduccionList}" var="data" id="dataCadenaCliente" 
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo"
                    

    >
        <h:column>
            <f:facet name="header">
                <h:outputText value=""  />
                
            </f:facet>
            <h:selectBooleanCheckbox value="#{data.checked}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Horas Máquina"  />
            </f:facet>
            <h:outputText value="#{data.horasMaquina}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Horas Hombre"  />
            </f:facet>
            <h:outputText value="#{data.horasHombre}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Fecha Inicio"  />
            </f:facet>
            <h:outputText value="#{data.fechaInicio}"  />
        </h:column>
        <%--
        <h:column>
            <f:facet name="header">
                <h:outputText value="Hora Inicio"  />
            </f:facet>
            <h:outputText value="#{data.horaInicio}"  />
        </h:column>
        --%>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Fecha Final"  />
            </f:facet>
            <h:outputText value="#{data.fechaFinal}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Maquina"  />
            </f:facet>
            <h:outputText value="#{data.maquinaria.nombreMaquina}"  />
        </h:column>
        <%--
        <h:column>
            <f:facet name="header">
                <h:outputText value="Hora Final"  />
            </f:facet>
            <h:outputText value="#{data.horaFinal}"  />
        </h:column>
        --%>
        
    </rich:dataTable>
    
    <br>
    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedActividadesProgramaproduccion.Guardar}"/>
    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedActividadesProgramaproduccion.actionEditar}" onclick="return eliminarItem('form1:dataCadenaCliente');"/>
    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedActividadesProgramaproduccion.eliminarSeguimientoPrograma}"  onclick="return eliminar('form1:dataCadenaCliente');"/>
    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="navegadorActividadPrograma"  />
    
</div>
<!--cerrando la conexion-->
<h:outputText value="#{ManagedActividadesFormulaMaestra.closeConnection}"  />
</h:form>


</body>
</html>


</f:view>

