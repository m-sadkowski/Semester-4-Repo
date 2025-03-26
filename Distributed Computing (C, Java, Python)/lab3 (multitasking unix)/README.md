1. Pytania ogólne dotyczące wieloprocesowości
   1. Co to jest wieloprocesowość i jakie korzyści przynosi w systemach operacyjnych?
   2. Czym różni się proces od wątku w systemie UNIX?
   3. Jakie zasoby mogą być współdzielone między procesami?

2. Pytania dotyczące powłoki systemowej
   1. Jaka jest rola powłoki (shell) w systemie UNIX?
   2. Jak sprawdzić, jaka powłoka została przydzielona użytkownikowi?
   3. Jakie są dwa główne rodzaje poleceń wykonywanych przez powłokę i czym się różnią?
   4. Jak działa mechanizm wykonywania poleceń w tle i jak można je przywrócić na pierwszy plan?

3. Pytania o zarządzanie procesami
   1. Jakie polecenie można wykorzystać do wyświetlenia listy uruchomionych procesów dla określonego użytkownika?
   2. Co oznacza symbol & na końcu polecenia w powłoce UNIX?
   3. Jakie polecenie pozwala wyświetlić listę wszystkich zadań uruchomionych w tle?
   4. Co robi polecenie `ps -u student | grep pts/1` i jak działa jego składnia?

4. Pytania dotyczące funkcji systemowych
   1. Jak działa funkcja `fork()` i jakie wartości może zwrócić?
   2. Co robi funkcja `getpid()` i `getppid()`?
   3. Jakie są różnice między funkcjami `execvp()`, `execlp()` i `execv()`?
   4. Do czego służy funkcja `waitpid()` i w jakim celu się ją wykorzystuje?
