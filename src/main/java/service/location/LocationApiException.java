package service.location;

public class LocationApiException extends RuntimeException {
    public LocationApiException(String message) {
        super(message);
    }

    public LocationApiException(String message, Throwable cause) {
        super(message, cause);
    }
}
