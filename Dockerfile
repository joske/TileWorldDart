FROM fischerscode/flutter

WORKDIR /app/

COPY pubspec.yaml .
RUN flutter get

COPY . .

CMD ["flutter", "run"]


