using UnityEngine;
using UnityEngine.SceneManagement;

public class PersistCanvas : MonoBehaviour
{
    public static PersistCanvas Instance;

    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else if (Instance != this)
        {
            Destroy(gameObject);
            return;
        }

        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    void OnDestroy()
    {
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        // Determine when to show or hide the wallet UI based on the scene's name or other criteria
        if (scene.name == "MiniGame(Arrow)" || scene.name.Contains("MiniGame")) // Adjust the scene names accordingly
        {
            HideUI();
        }
        else
        {
            ShowUI();
        }
    }

    void HideUI()
    {
        gameObject.SetActive(false); // Or target specific components
    }

    void ShowUI()
    {
        gameObject.SetActive(true); // Or target specific components
    }
}
