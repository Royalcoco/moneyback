from data_processing import load_data, preprocess_data
from model import train_model, save_model, load_model
from predict import make_prediction
import subprocess

def main():
    # Charger et traiter les données
    data, labels = load_data('data/text_data.csv')
    processed_data = preprocess_data(data)
    
    # Entraîner le modèle
    model = train_model(processed_data, labels)
    
    # Sauvegarder le modèle
    save_model(model, 'model/text_classifier.pkl')
    
    # Charger le modèle et faire une prédiction
    loaded_model = load_model('model/text_classifier.pkl')
    sample_text = "Ceci est un texte d'exemple pour prédiction."
    prediction = make_prediction(loaded_model, sample_text)
    
    print(f"Prédiction pour le texte: {prediction}")

if __name__ == "__main__":
    main()

    def send_ping(host):
        try:
            subprocess.check_output(["ping", "-c", "1", host])
            print(f"Ping sent to {host}")
        except subprocess.CalledProcessError:
            print(f"Failed to send ping to {host}")

    # Exemple d'utilisation
    send_ping("google.com")
    send_ping("fakehost")
    
    def send_ping(host):
        
        try:
            subprocess.check_output(["ping", "-c", "1", host])
            print(f"Ping sent to {host}")
            return True
        except subprocess.CalledProcessError:
            print(f"Failed to send ping to {host}")
            return False
        
    
    def main():
        # Charger et traiter les données
        data, labels = load_data('data/text_data.csv')
        processed_data = preprocess_data(data)
        
        # Entraîner le modèle
        model = train_model(processed_data, labels)
        
        # Sauvegarder le modèle
        save_model(model, 'model/text_classifier.pkl')
        
        # Charger le modèle et faire une prédiction
        loaded_model = load_model('model/text_classifier.pkl')
        sample_text = "Ceci est un texte d'exemple pour prédiction."
        prediction = make_prediction(loaded_model, sample_text)
        
        print(f"Prédiction pour le texte: {prediction}")
        
        # Envoyer un ping à google.com
        send_ping("google.com")
        
        # Envoyer un ping à un hôte inexistant
        send_ping("fakehost")
        
    if __name__ == "__main__":
        main()  # main() est exécuté si le script est exécuté directement, sinon il n'est pas exécuté si le script est importé comme un module.
        
    def send_ping(host):
        try:
            subprocess.check_output(["ping", "-c", "1", host])
            print(f"Ping sent to {host}")
            return True
        except subprocess.CalledProcessError:
            print(f"Failed to send ping to {host}")
            return False
        
    def main():
        # Charger et traiter les données
        data, labels = load_data('data/text_data.csv')
        processed_data = preprocess_data(data)
        
        # Entraîner le modèle
        model = train_model(processed_data, labels)
        
        # Sauvegarder le modèle
        save_model(model, 'model/text_classifier.pkl')
        
        # Charger le modèle et faire une prédiction
        loaded_model = load_model('model/text_classifier.pkl')
        sample_text = "Ceci est un texte d'exemple pour prédiction."
        prediction = make_prediction(loaded_model, sample_text)
        
        print(f"Prédiction pour le texte: {prediction}")
        
        # Envoyer un ping à google.com
        send_ping("google.com")
        
        # Envoyer un ping à un hôte inexistant
        send_ping("fakehost")
        
    if __name__ == "__main__":
        main()
        
    def send_ping(host):
        try:
            subprocess.check_output(["ping", "-c", "1", host])
            print(f"Ping sent to {host}")
            return True
        except subprocess.CalledProcessError:
            print(f"Failed to send ping to {host}")
            return False
        
