using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainGameManag : MonoBehaviour
{
    public static MainGameManag Instance;

    void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject);
        }
        else
        {
            Destroy(gameObject);
        }
    }

    public void LoadMiniGame()
    {
        SceneManager.LoadScene("MiniGame(Arrow)");
    }

    public void ReturnToMainGame(bool miniGameSuccess)
    {
        SceneManager.LoadScene("Main");
        if (miniGameSuccess)
        {
            Debug.Log("Mini-game succeeded: Creature captured.");
            // Add logic to add creature to inventory
        }
        else
        {
            Debug.Log("Mini-game failed: Creature escaped.");
        }
    }
}

