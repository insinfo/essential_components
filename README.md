# Essencials Components
Uma biblioteca para desenvolvedores AngularDart.
<i>Em construção</i>

## Instalação
1. Adicione a dependência em seu gerenciador de pacotes dentro do arquivo pubspec.yaml.
```yaml
dependencies:
  essential_components: ^0.1.2
```
2. Instale usando o comando `pub get`

3. Para usar basta importar a implementação dentro do seu componente:

```dart
import 'package:essential_components/essential_components.dart';
```

## Componentes presentes
- Datatable
- Select Dialog
- Notification
- Toast

## Como usar
É extremamente simples a forma de usar os componentes essenciais.

#### Datatable
O datatable é um componente que organiza as os dados que são consumidos em um serviço, onde o mesmo devem possuir um estrutura defina tanto para o request, quanto para o response dos dados.

A principio, existe uma estrutura de dados que é enviada como 'Query Params'. Esses dados são muito relevantes para a funcionalidade de filtros. Logo, o backend da aplicação deverá tratar esses dados caso o desenvolvedor queira realizar pesquisas baseados em filtros. Esses parâmetros são expressados na seguinte estrutura de dados:

```dart
int limit;
int offset;
String search;
String orderBy;
String orderDir;
```

Por padrão, ao contrário do backend da aplicação, o Datatable já possuí esses dados tratados no frontend (Dart), logo os filtros ocorrem automáticamente.

Agora que já estamos ciente do que é preciso para funcionar a base de filtragem, vamos direcionar o foco para a renderização do nosso Datatable.

##### Definiando o modelo de negócios

Para que o Datatable possa funcionar, o primeiro passo é implementar o modelo de negócio com a interface IDataTableRender. Por exemplo:

```dart
class Categoria implements IDataTableRender {
  int id;
  String nome;

  @override
  DataTableRow getRowDefinition() {
    DataTableRow settings = DataTableRow();
    settings.addSet(DataTableColumn(key: 'id', value: idAsString, title: 'Id'));
    settings.addSet(DataTableColumn(key: 'nome', value: nome, title: 'Nome'));
    return settings;
  }
}
```

A classe implementada sobrescreve um método que retorna um `DataTableRow`, chamado `getRowDefinition()`. Este método é respectivo a configuração de cabeçalho do Datatable. Onde é instanciado uma linha, e as colunas com o DataTableColumn. O DataTableColumn recebe alguns parâmetros pertinentes a sua configuração:
```dart
    class DataTableColumn {
        dynamic key;
        dynamic value;
        DataTableColumnType type;
        String title;
        int limit;
        String format;
        bool primaryDisplayValue;
    }
```
Vamos seguir o exemplo da nossa classe de categoria:

````dart
class Categoria implements IDataTableRender {
  int id;
  String nome;
}
```

```dart
dynamic key; //essa seria a chave. Ex.: 'nome'
dynamic value; //este seria o valor do campo. Ex: nome
DataTableColumnType type; // DataTableColumnType.text. Esses são os tipos presentes no Enum. Eles são: img, text, date, dateTime
String title; // 'Id'
int limit; //Limitar a quanidade de caracteres
String format; // Para alguns tipos existem uma formatação específica.
bool primaryDisplayValue; //Caso houver exibir uma unica coluna, qual a coluna vai ser exibida. Muito usada no select dialog.
```

Agora, o processo de renderização esta pré moldado para ser trabalhado dentro do seu componente angular dart.

Para isso, basta instanciar o componente referenciando a view.
```dart
@ViewChild('dataTable')
EssentialDataTableComponent dataTable;
```

Esta tabela emite alguns eventos. Entre os mais importantes, estão:
rowClick: Ao clicar, o objeto é retornado.
dataRequest: Pertinentes aos filtros a serem renderizados

o Inline da view do template, ficaria destacado da seguinte forma:

```html
<es-data-table
    #dataTable
    [data]="categorias"
    (rowClick)="onRowClick($event)"
    (dataRequest)="onRequestData($event)">
</es-data-table>
```

Os métodos onRowClient($event) e onRequestData($event), ambos precisam ser implementados no componente definindo lógicas de negócios.

Por exemplo... com o onRowClick($event), é possível navegar para outra página salvando uma refeerência de um objeto para realizar uma atualização de um objeto de dados.

```dart
    onRowClick(event) {
        this.categoria = event; //rebendo instancia do objeto categoria
        goToDetail();
    }
```

É preciso implementar o OnRequest data simplesmente para colher o filtro da tabela.
```dart
Future<void> onRequestData(DataTableFilter dataTableFilter) async {
    await getAllCampanhas(filters: dataTableFilter);
}
```