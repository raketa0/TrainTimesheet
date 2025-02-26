 //Рычков Александр Александрович
 // Паскаль АБС.НЕТ
 {17. На   узловой   станции  необходимо  менять  направления
движения всех  поездов.  Для  этого  предназначен  специальный
тупик.  Зашедший  в  тупик  последний  поезд  выходит  из него
первым.  Известны  моменты  прихода   поездов   и   минимально
необходимое   время   стоянки (одинаковое  для всех  поездов).
Требуется:
   1) составить расписание стоянки поездов на станции с учетом
смены направления движения;
   2) поменять   между   собой   моменты   прихода   скорых  и
пассажирских  поездов   так,   чтобы   скорые   поезда   имели
минимальное суммарное время простоя в тупике (9).}
//сумма времен процедура!!!!!!!!
const
  separator = '/';
  second = 'passenge';
  first = 'fast';
  null = 0.00000000001;
type
Ukazat = ^timesheet;
timesheet = record
              NameTrain: string;//название поезда
              TypeTrain: string;//тип поезда pesenger/fast
              Arrival: real;//прибытие
              Departure: real;//отправление
              Expectation: real;// лишний простой
              Next: Ukazat;
            end;
var
  NewNameTrain: string;
  flagTypeTrain: string;
  input,output: text;
  inputFile, outputFile: string;
  timeExpecationTrain: real;
  Head: Ukazat;
  NewTrain: Ukazat;
  flagHead: Ukazat;
function TimeFromReal(var Head: Ukazat; timeExpecationTrain: real): real;
var
  time: real;
  begin
    time:= Head^.Arrival + timeExpecationTrain;
    if frac(time) >= 0.6
    then
      begin
        time:= time + 1 - 0.6;
        TimeFromReal := time;
      end
    else
      TimeFromReal := time;
    if frac(Head^.Arrival) >= 0.6
    then
      begin
        writeln('Ошибка неправильный ввод прибытия поезда ', Head^.NameTrain);
        exit
      end;
      
  end;
procedure СalcDepartureAndExpectation(var Head: Ukazat;   timeExpecationTrain: real);
var
  flag: Ukazat;
  flagHead: Ukazat;
  flagHeadOne: Ukazat;
begin
  flag:= Head;
  flagHead:= Head;
  flagHeadOne:= flagHead^.next;
  flagHead^.Departure:= TimeFromReal(flagHead, timeExpecationTrain);
  while flagHeadOne <> nil do
    begin  
    if (flagHeadOne^.Arrival - flagHead^.Arrival) <= timeExpecationTrain
    then
      begin
        if TimeFromReal(flagHeadOne, timeExpecationTrain) > flagHead^.Departure
        then
          begin
            flagHead:= flag;
            while flagHead <> flagHeadOne do
            begin
              flagHead^.Departure:= TimeFromReal(flagHeadOne, timeExpecationTrain);
              flagHead^.Expectation:= abs(flagHead^.Departure-flagHead^.Arrival-timeExpecationTrain);
              flagHead:= flagHead^.next;
            end;
            flagHead^.Departure:= TimeFromReal(flagHeadOne, timeExpecationTrain);
            flagHead^.Expectation:= abs(flagHead^.Departure-flagHead^.Arrival-timeExpecationTrain);
            flagHeadOne:= flagHead^.next;
          end      
      end
    else 
      begin
        flag:= flagHeadOne;
        flagHeadOne^.Departure:= TimeFromReal(flagHeadOne, timeExpecationTrain);
        flagHeadOne^.Expectation:= abs(flagHeadOne^.Departure-flagHeadOne^.Arrival-timeExpecationTrain);
        flagHead:= flagHead^.Next;
        flagHeadOne:= flagHead^.Next;
      end;
    end
end;
procedure push(var Head: Ukazat; NewTrain: Ukazat);
begin
  new(NewTrain);
  NewTrain^.next := head;
  Head := NewTrain;
end;
procedure SortTrain(var Head: Ukazat);
var
  Current: Ukazat;
  Prev: Ukazat;
  Temp: Ukazat;
  Swapped: boolean;
begin
  Swapped := True;
  while Swapped do
  begin
    Swapped := False;
    Current := Head;
    Prev := nil;
    while Current <> nil do
    begin
      if (Current^.Next <> nil) and (Current^.Arrival > Current^.Next^.Arrival) then//
      begin
        // Обмен элементов
        Temp := Current^.Next;
        Current^.Next := Temp^.Next;
        Temp^.Next := Current;
        if Prev <> nil then
          Prev^.Next := Temp
        else
          Head := Temp;
        Swapped := True;
      end;
      Prev := Current;
      Current := Current^.Next;
    end;
  end;
end;
procedure ReadTimesheet(var input:text; var Head: Ukazat; timeExpecationTrain: real);
var
  flag: string;
  ch: char;
  begin
    while not eof(input) do
    begin
      push(Head, NewTrain);
      while ch <> separator do
      begin
        read(input, ch);
        if ch <> separator
        then
          flag:= flag + ch
        else
          begin
            Head^.NameTrain := flag;
            flag:='';
            ch:='.';
            break;
          end;
      end;
      while ch <> separator do
      begin
        read(input, ch);
        if ch <> separator
        then
          flag:= flag + ch
        else
          begin
            Head^.TypeTrain := flag;
            
            flag:='';
            break;
          end;
      end;
      read(input, Head^.Arrival);
      readln(input, ch);
    end;
      SortTrain(Head);
      СalcDepartureAndExpectation(Head, timeExpecationTrain);
  end;
procedure OptimizedTimesheet(var Head: Ukazat);
var
  i: integer;
  flag, flagHead: Ukazat;
  Current: Ukazat;
  Prev: Ukazat;
  Temp: Ukazat;
  Swapped: boolean;
begin
  Swapped := True;
  while Swapped do
  begin
    Swapped := False;
    Current := head;
    Prev := nil;
    while Current <> nil do
    begin
      if (Current^.Next <> nil) and (Current^.Expectation > Current^.Next^.Expectation) then//
      begin
        // Обмен элементов
        Temp := Current^.Next;
        Current^.Next := Temp^.Next;
        Temp^.Next := Current;
        if Prev <> nil then
          Prev^.Next := Temp
        else
          head := Temp;
        Swapped := True;
      end;
      Prev := Current;
      Current := Current^.Next;
    end;
  end;
  flag:= head;
  flagHead:= head;
  while flagHead^.Expectation < null do
  begin
    while flagHead^.TypeTrain <> first do
    begin
      if (flagHead^.TypeTrain = first) and (flagHead^.Expectation > null)
      then
        break
      else
        flagHead:= flagHead^.next;
    end;
    if (flagHead^.TypeTrain = first) and (flagHead^.Expectation > null)
    then
      break
    else
      flagHead:= flagHead^.next;
  end;
  while flag^.TypeTrain <> second do
  begin
    flag:= flag^.next 
  end;
  while flagHead <> nil do
  begin
    if (flag^.TypeTrain = second) and (flagHead^.TypeTrain = first) and (flag^.Expectation < flagHead^.Expectation)
    then
      begin
        NewNameTrain:= flagHead^.NameTrain;
        flagTypeTrain:= flagHead^.TypeTrain;
        flagHead^.NameTrain := flag^.NameTrain;
        flagHead^.TypeTrain:=  flag^.TypeTrain;
        flag^.NameTrain:= NewNameTrain;
        flag^.TypeTrain:= flagTypeTrain;
      end;
    flag:= flag^.next;
    flagHead:= flagHead^.next;
    if (flag^.TypeTrain = first) and (flag^.Expectation < null) and (flag <> nil)
    then 
      flag:= flag^.next;
    if flagHead <> nil
    then
    if (flagHead^.TypeTrain = first) and (flagHead^.Expectation < null) 
    then 
      flagHead:= flagHead^.next;
  end;
 SortTrain(Head);
end;
 //Основная программа
  begin
    head:= nil;
    writeln('Введите входной файл');
    readln(inputFile);
    assign(input, inputFile);
    reset(input);
    readln(input, timeExpecationTrain);
    Head:= nil;
    ReadTimesheet(input, Head, timeExpecationTrain);
    flagHead:= Head;
    writeln('NameTrain    TypeTrain    ArrivalTrain    DepartureTrain    ExpectationTrain');
    while flagHead <> nil
    do
      begin
        if flagHead^.TypeTrain = 'fast'
        then
          writeln(flagHead^.NameTrain, '       ' , flagHead^.TypeTrain, '         ' , flagHead^.Arrival:0:2, '           ' , flagHead^.Departure:0:2,'             ', flagHead^.Expectation:0:2)
        else
          writeln(flagHead^.NameTrain, '       ' , flagHead^.TypeTrain, '     ' , flagHead^.Arrival:0:2, '           ' , flagHead^.Departure:0:2,'             ', flagHead^.Expectation:0:2);
        flagHead:= flagHead^.next;
      end; 
    close(input);
    OptimizedTimesheet(Head);
    writeln('');
    writeln('Оптимизированное расписание');
    writeln('');
    writeln('NameTrain    TypeTrain    ArrivalTrain    DepartureTrain    ExpectationTrain');  
    while Head <> nil
    do
      begin
        if Head^.TypeTrain = 'fast'
        then
          writeln(Head^.NameTrain, '       ' , Head^.TypeTrain, '         ' , Head^.Arrival:0:2, '           ' , Head^.Departure:0:2,'             ', Head^.Expectation:0:2)
        else
          writeln(Head^.NameTrain, '       ' , Head^.TypeTrain, '     ' , Head^.Arrival:0:2, '           ' , Head^.Departure:0:2,'             ', Head^.Expectation:0:2);
        Head:= Head^.next;
      end; 
    
  //  writeln('Введите выходной файл');
  //  read(outputFile);
  //  assign(output, outputFile);
  //  rewrite(output);
  //  close(output);
  end.