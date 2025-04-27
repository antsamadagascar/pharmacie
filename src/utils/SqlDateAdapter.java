package utils;

import com.google.gson.TypeAdapter;
import com.google.gson.stream.JsonReader;
import com.google.gson.stream.JsonWriter;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class SqlDateAdapter extends TypeAdapter<java.sql.Date> {
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd", Locale.US);

    @Override
    public void write(JsonWriter out, java.sql.Date value) throws IOException {
        if (value == null) {
            out.nullValue();
        } else {
            out.value(sdf.format(value));
        }
    }

    @Override
    public java.sql.Date read(JsonReader in) throws IOException {
        try {
            String dateStr = in.nextString();
            Date utilDate = sdf.parse(dateStr);
            return new java.sql.Date(utilDate.getTime());
        } catch (ParseException e) {
            throw new IOException("Date invalide : " + in.nextString(), e);
        }
    }
}
